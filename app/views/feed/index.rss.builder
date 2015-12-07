xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Aktualności PJA"
    xml.author "Polsko-Japońska Akademia Technik Komputerowych"
    xml.description "Aktualności z PJA"
    xml.link ENV["APP_HOST"] + "/feed.rss"
    xml.language "pl"

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.author "Polsko-Japońska Akademia Technik Komputerowych"
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.link article.url
        xml.guid article.id

        if text = article.content
          xml.description "<p>" + text + "</p>"
        else
          xml.description ""
        end
      end
    end
  end
end
