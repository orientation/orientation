module OpenSearch
  module DescriptionsHelper
    def open_search_description_link_tag
      content_tag(
        :link,
        nil,
        rel: 'search',
        type: 'application/opensearchdescription+xml',
        title: ENV.fetch('APP_NAME', 'Orientation'),
        href: open_search_description_path
      )
    end
  end
end
