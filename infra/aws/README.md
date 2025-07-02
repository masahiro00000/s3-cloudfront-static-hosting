# Static Website Infrastructure – Terraform

このディレクトリでは、静的コンテンツを **S3 + CloudFront + Route 53** で配信し、Terraform のステートを **S3 ロックファイル** で管理するコードを提供します。

---

## ディレクトリ構成

```text
infra/aws/
├ backend_setup.tf      # tfstate バケット（バージョニング + lockfile）
├ backend.tf            # S3 backend 定義 (コメント解除後に有効)
├ provider.tf           # default (ap-northeast-1) & alias us-east-1
├ versions.tf           # Terraform / provider バージョン
├ variables.tf          # ドメイン・リージョン等の変数
├ s3.tf                 # 静的サイト用バケット & ログバケット
├ acm.tf                # ACM 証明書 (us-east-1, DNS 検証)
├ cloudfront.tf         # CloudFront Distribution
├ route53.tf            # ALIAS & 検証用 Route 53 レコード
├ outputs.tf            # 主要リソースの出力
└ README.md             # このドキュメント
```

---

## 変数

| 変数名            | デフォルト                        | 説明                           |
| ----------------- | -------------------------------- | ------------------------------ |
| `region`          | `ap-northeast-1`                 | プライマリリージョン           |
| `domain_name`     | `dummy.com`                      | CloudFront が配信する FQDN     |
| `hosted_zone_id`  | `DUMMYIDXXXXXXXXXXXXXX`          | 既存 Route 53 ホストゾーン ID  |

必要に応じて `terraform.tfvars` で上書きしてください。

---

## 初回デプロイ手順

1. **backend.tf を一時的にコメントアウト**  
   （バックエンド未設定 = ローカルステート）
2. 初期化 & 適用  
   ```bash
   cd infra/aws
   terraform init
   terraform apply
   ```  
   ここで **tfstate バケット** が作成されます。
3. **backend.tf のコメントを解除**（S3 backend を有効化）し、ステートを移行  
   ```bash
   terraform init -migrate-state
   ```
4. リモートステート化後は通常の `terraform plan / apply` を実行してください。

---

## 2 回目以降のデプロイ

```bash
cd infra/aws
terraform init         # backend は S3
terraform plan
terraform apply        # 必要に応じて -auto-approve
```

---

## コンテンツアップロード

静的ファイルは **`<project_prefix>-website` バケット**（例: `s3-cloudfront-static-hosting-website`）直下へ配置します。  
`aws s3 sync` などを利用してください。

```bash
aws s3 sync ./public s3://s3-cloudfront-static-hosting
```

※ コンテンツ更新後、キャッシュを即時反映したい場合は CloudFront の **無効化 (invalidation)** を行います。  
（参考コマンド）

```bash
aws cloudfront create-invalidation \
  --distribution-id <DistributionID> \
  --paths "/*"
```

---

## GitHub Actions 例

OIDC + AssumeRole を前提にしたサンプルです。  
`role-to-assume` にはデプロイ用 IAM ロールを設定し、最小権限ポリシーを付与してください。

```yaml
name: terraform

on:
  push:
    branches: [ main ]

permissions:
  id-token: write     # OIDC 用
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: infra/aws

    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<ACCOUNT_ID>:role/TerraformDeployRole
          aws-region: ap-northeast-1

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.8.5

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve tfplan
```

---

## 参考

- CloudFront 価格クラス: `PriceClass_All`（必要に応じて変更）  
- Viewer Certificate: TLS 1.2_2021, SNI-only  
- バケットは **バージョニング + SSE** を有効化  
- tfstate バケットは `prevent_destroy = true` で誤削除防止

以上でセットアップ完了です。Happy Terraforming!
