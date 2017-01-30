module OpenSearch
  class DescriptionsController < ApplicationController
    respond_to :osd_xml
    # Serves the OpenSearch Description document so that you can use the omnibox
    # and similar to search on Orientation.
    def show
    end
  end
end
