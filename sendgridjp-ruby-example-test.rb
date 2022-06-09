require 'sendgrid-ruby'
require 'dotenv'
require 'test/unit'
include SendGrid

class Sample
    def self.send
        # .envから環境変数を読み込む
        Dotenv.load
        sendgrid_api_key = ENV['API_KEY']
        from = ENV['FROM']
        tos = ENV['TOS'].split(',')

        # メールの送信元を設定する
        mail = SendGrid::Mail.new
        mail.from = Email.new(email: from, name: '送信者名')

        #メールの件名と本文を作成する
        mail.subject = '[sendgrid-ruby-example] フクロウの名前は%fullname%さん'
        mail.add_content(Content.new(type: 'text/plain', value: 'some text here'))
        mail.add_content(Content.new(type: 'text/html', value: '<html><body> %familyname%さんは何をしていますか？<br>彼は%place%にいます。</body></html>'))

        # 1つ目の宛先と、対応するSubstitutionタグを指定する
        personalization1 = Personalization.new
        personalization1.add_to(Email.new(email: tos[0]))
        personalization1.add_substitution(Substitution.new(key: '%fullname%', value: '田中 太郎'))
        personalization1.add_substitution(Substitution.new(key: '%familyname%', value: '田中'))
        personalization1.add_substitution(Substitution.new(key: '%place%', value: '中野'))
        mail.add_personalization(personalization1)

        # 2つ目の宛先と、対応するSubstitutionタグを指定する
        personalization2 = Personalization.new
        personalization2.add_to(Email.new(email: tos[1]))
        personalization2.add_substitution(Substitution.new(key: '%fullname%', value: '佐藤 次郎'))
        personalization2.add_substitution(Substitution.new(key: '%familyname%', value: '佐藤'))
        personalization2.add_substitution(Substitution.new(key: '%place%', value: '目黒'))
        mail.add_personalization(personalization2)

        # 3つ目の宛先と、対応するSubstitutionタグを指定する
        personalization3 = Personalization.new
        personalization3.add_to(Email.new(email: tos[2]))
        personalization3.add_substitution(Substitution.new(key: '%fullname%', value: '鈴木 三郎'))
        personalization3.add_substitution(Substitution.new(key: '%familyname%', value: '鈴木'))
        personalization3.add_substitution(Substitution.new(key: '%place%', value: '中野'))
        mail.add_personalization(personalization3)

        # カテゴリ情報を付加する
        mail.add_category(Category.new(name: 'Category1'))

        # カスタムヘッダを利用する
        mail.add_header(Header.new(key: 'X-Sent-Using', value: 'SendGrid-API'))

        # 画像を添付する
        attachment = Attachment.new
        attachment.content = Base64.strict_encode64(File.read("gif.gif"))
        attachment.filename = 'owl.gif'
        mail.add_attachment(attachment)

        # 認証情報を指定する
        sg = SendGrid::API.new(api_key: sendgrid_api_key)

        # メール送信を行い、レスポンスを表示させる
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts response.status_code
        puts response.body
        puts response.headers
        return response.status_code
    end
end

class TestSend < Test::Unit::TestCase
    def test_send
        status_code = Sample.send
        assert_equal "202", status_code
    end
end