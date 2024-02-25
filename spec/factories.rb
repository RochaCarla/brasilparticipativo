# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"
require "decidim/assemblies/test/factories"
require "decidim/proposals/test/factories"
require "decidim/comments/test/factories"
require "decidim/accountability/test/factories"
require "decidim/meetings/test/factories"
require "decidim/homes/test/factories"
require "decidim/blogs/test/factories"

FactoryBot.define do
  factory :partner, class: "Decidim::Govbr::Partner" do
    name { "partner" }
    weight { 1 }

    trait :as_organizer do
      partner_type { "organizer" }
    end

    trait :as_supporter do
      partner_type { "supporter" }
    end
  end

  factory :govbr_media_link, class: "Decidim::Govbr::MediaLink" do
    title { generate_localized_title }
    weight { Faker::Number.between(from: 1, to: 10) }
    link { Faker::Internet.url }
    date { 1.month.ago }
  end

  factory :page_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :pages).i18n_name }
    manifest_name { :pages }
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }
  end

  factory :page, class: "Decidim::Pages::Page" do
    body { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    component { build(:component, manifest_name: "pages") }
  end

  factory :statistic_setting, class: "Decidim::Govbr::UserProposalsStatisticSetting" do
    name { "User Proposals Statistic Report" }
    proposals_done_weight { Faker::Number.between(from: 1, to: 10) }
    comments_done_weight { Faker::Number.between(from: 1, to: 10) }
    votes_done_weight { Faker::Number.between(from: 1, to: 10) }
    follows_done_weight { Faker::Number.between(from: 1, to: 10) }
    votes_received_weight { Faker::Number.between(from: 1, to: 10) }
    comments_received_weight { Faker::Number.between(from: 1, to: 10) }
    follows_received_weight { Faker::Number.between(from: 1, to: 10) }
    users_to_be_exported { Faker::Number.between(from: 1, to: 10) }
  end
end
