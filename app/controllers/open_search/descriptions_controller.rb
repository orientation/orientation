module OpenSearch
  class DescriptionsController < ApplicationController
    layout false

    respond_to :osd_xml

    skip_before_action :authenticate_user!

    # Serves the OpenSearch Description document so that you can use the omnibox
    # and similar to search on Orientation.
    def show
    end
  end
end
