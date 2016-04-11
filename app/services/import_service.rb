require "open-uri"

class ImportService

  attr_reader :imported

  def initialize
    @imported = 0
    @articles = []
    @year     = Time.current.year
  end

  def call
    @document = load_document(build_url(ENV["PJA_PATH"]))
    read_document
    import_results
  end

  private

  def load_document(url)
    Nokogiri::HTML(open(url))
  end

  def read_document
    @document.css(".introText > *").each do |node|
      if node.node_name == "p"
        parse_article(node)
      elsif node.node_name == "h3"
        change_year(node)
      end
    end
  end

  def parse_article(article)
    if link = article.at_xpath("a")
      @articles << {
        title: fetch_title(article),
        date: fetch_date(article),
        path: fetch_path(article),
        content: fetch_content(article)
      }
    end
  end

  def fetch_title(article)
    article.at_xpath("a").try(:text)
  end

  def fetch_date(article)
    if match = /(\d{2})\.(\d{2})/.match(article.at_xpath("text()").text)
      {
        day: match[1].to_i,
        month: match[2].to_i,
        year: @year
      }
    end
  end

  def fetch_path(article)
    if link = article.at_xpath("a")
      link.attribute("href").try(:text)
    end
  end

  def fetch_content(article)
    if path = fetch_path(article)
      url = build_url(path)
      return if (url =~ /https?\:\/\/www\.pja\.edu\.pl/).nil?
      if article_document = load_document(url) rescue nil
        if text_node = article_document.at_css(".news_content_text .fullText")
          text_node.text.gsub(/\s+/, " ")
        end
      end
    end
  end

  def change_year(node)
    /ROK (20\d{2})/.match(node.text) do |match|
      @year = match[1].to_i
    end
  end

  def import_results
    ActiveRecord::Base.transaction do
      @articles.each do |parsed_article|
        published_at = nil

        if parsed_article[:date].present?
          published_at = Date.new(
            parsed_article[:date][:year],
            parsed_article[:date][:month],
            parsed_article[:date][:day]
          )
        end

        article = Article.find_or_initialize_by(
          url: build_url(parsed_article[:path])
        )

        article.title         = parsed_article[:title]
        article.published_at  = published_at
        article.content       = parsed_article[:content]

        article.save!
      end
    end
  end

  def build_url(path_or_url)
    return path_or_url unless (path_or_url =~ /https?\:\/\//).nil?
    "http://" + ENV["PJA_HOST"] + path_or_url
  end
end
