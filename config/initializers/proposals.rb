Decidim.component_registry.find(:proposals).settings(:global) do |settings|
  settings.attribute :most_voted_rule, type: :integer, default: 0
  settings.attribute :enable_comments_attachment, type: :boolean, default: false
  settings.attribute :requires_previous_moderation, type: :boolean, default: false
end
