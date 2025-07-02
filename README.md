# s3-cloudfront-static-hosting

このリポジトリは、**AWS S3 + CloudFront + Route 53** を用いた静的ウェブサイトホスティングのインフラ構築テンプレートです。  
Terraform によるインフラ管理と、開発効率を高めるための DevContainer 設定が含まれています。

---

## 構成概要

- `infra/aws/`  
  Terraform コード一式を格納しています。S3 バケット、CloudFront、Route 53 などのリソース定義や、デプロイ手順、変数の説明などは [infra/aws/README.md](infra/aws/README.md) を参照してください。

- `.devcontainer/`  
  VS Code Dev Containers 用の設定ディレクトリです。  
  AWS CLI、Terraform、Node.js などの開発ツールがプリインストールされています。  
  **AWS CLI の認証情報は、ホストマシンの `~/.aws` ディレクトリをコンテナ内 `/home/vscode/.aws/` にマウントすることで利用できます。**  
  詳細は `.devcontainer/devcontainer.json` の `mounts` 設定を参照してください。

---

## 利用方法（概要）

1. DevContainer でワークスペースを開きます（VS Code 推奨）。
2. ホスト側の `~/.aws` ディレクトリに認証情報をセットアップしてください（`aws configure` など）。
3. `infra/aws/` ディレクトリ内の手順に従い、Terraform でインフラをデプロイします。

---

詳細なセットアップ・運用手順や変数の説明は [infra/aws/README.md](infra/aws/README.md) をご覧