xml.instruct!
xml.OpenSearchDescription xmlns: 'http://a9.com/-/spec/opensearch/1.1/', 'xmlns:moz': 'http://www.mozilla.org/2006/browser/search/', 'xmlns:suggestions': 'http://www.opensearch.org/specifications/opensearch/extensions/suggestions/1.1' do
  xml.AdultContent false
  xml.Description "Search on #{ENV.fetch('APP_NAME', 'Orientation')}"
  if ENV['ORIENTATION_FAVICON'].present?
    xml.Image ENV['ORIENTATION_FAVICON'], width: 16, height: 16, type: 'image/x-icon'
  end
  if ENV['ORIENTATION_LOGO'].present?
    xml.Image ENV['ORIENTATION_LOGO'], width: 64, height: 64, type: 'image/png'
  end
  xml.InputEncoding 'UTF-8'
  xml.Language 'en-US'
  xml.Language '*'
  xml.LongName "#{ENV.fetch('APP_NAME', 'Orientation')} Search"
  xml.OutputEncoding 'UTF-8'
  xml.Query role: 'example', searchTerms: 'john smith'
  xml.ShortName ENV.fetch('APP_NAME', 'Orientation')
  xml.SyndicationRight 'limited'
  xml.tag! 'moz:SearchForm', articles_url
  # rels: results (default), suggestions, self, collection
  # parameters: searchTerms (required), count, startIndex, startPage, language, inputEncoding, outputEncoding
  xml.Url type: 'application/opensearchdescription+xml', rel: 'self', template: open_search_description_url
  xml.Url type: 'text/html', template: "#{articles_url}?search={searchTerms}&utm_source=opensearch&utm_medium=search&utm_campaign=opensearch"
end
