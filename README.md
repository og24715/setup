# setup

Mac の初期セットアップを Homebrew + Ansible で自動化します。

スクリプトをダウンロードしてから、ターミナルで実行してください。

```sh
curl -OL https://github.com/og24715/setup/raw/main/setup.sh
bash setup.sh
```

> [!IMPORTANT]
> `curl ... | sh` のようにパイプで実行しないでください。
> Homebrew のインストーラと sudo が標準入力（TTY）を必要とするため、パイプ実行では
> Homebrew のインストールに失敗するか、スクリプトの残り行がインストーラに読み取られて
> `ansible-playbook` まで到達しません。
> 実行中、pkg 形式の cask（google-japanese-ime など）のインストールのため
> macOS のパスワード入力を求められます。
