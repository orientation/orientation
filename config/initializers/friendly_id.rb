module FriendlyIdOverride
  def should_generate_new_friendly_id?
    slug_column_empty? || slug_base_changed?
  end

  def slug_column_empty?
    public_send("#{friendly_id_config.slug_column}").blank?
  end

  def slug_base_changed?
    public_send("#{friendly_id_config.base}_changed?")
  end
end

FriendlyId.defaults do |config|
  config.use :reserved, :slugged, :history

  config.reserved_words = %w(new edit index session login logout users admin
    stylesheets assets javascripts images)

  config.use(FriendlyIdOverride)
end
