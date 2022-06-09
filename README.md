# sendgridjp-go-example-test [![sendgridjp-ruby-example-test](https://circleci.com/gh/yken2257/sendgridjp-ruby-example-test.svg)](https://app.circleci.com/pipelines/github/yken2257/sendgridjp-ruby-example-test)
[SendGridJPのRubyサンプルコード](https://github.com/SendGridJP/sendgridjp-ruby-example)の動作確認のためのリポジトリです。

## 概要
CircleCI上でRuby3.1とSendGrid公式ライブラリ(>=6.6.0)をインストールし、サンプルコードの動作検証をします。
具体的には、サンプルコードの最後でHTTPレスポンスコード202が返ってくればテスト成功とみなします。

- sendgridjp-ruby-example-test.rb: [サンプルコード](https://github.com/SendGridJP/sendgridjp-ruby-example/blob/master/sendgridjp-ruby-example.rb)をテストするコード
- .circleci/config.yml: CircleCI設定（環境設定、環境変数設定、テストののち、用いたバージョンを表示します。毎月2日の午前9時に定期実行されます。）

（手動でテストする場合の手順）

```bash
# Install dependencies
bundle install
# .envファイルを編集
echo "API_KEY=$SENDGRID_API_KEY" >> .env
echo "TOS=alice@sink.sendgrid.net,bob@sink.sendgrid.net,carol@sink.sendgrid.net" >> .env
echo "FROM=you@example.com" >> .env
# Show Version
ruby -version
cat Gemfile.lock
# Test
ruby sendgridjp-ruby-example-test.rb
```