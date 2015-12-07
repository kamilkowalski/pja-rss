# RSS PJA

Aplikacja ta udostępnia wiadomości ze strony internetowej [PJA](http://www.pja.edu.pl/aktualnosci/glowna) w formacie RSS i JSON.

Scraping danych odbywa się co 30 minut. Do scrapingu wykorzystuję nokogiri odpalane w rake tasku za pomocą Heroku Scheduler.

Aplikacja jest hostowana na [Heroku](http://pja-rss.herokuapp.com), gdzie znajdują się podstawowe informacje i linki do feedów.
