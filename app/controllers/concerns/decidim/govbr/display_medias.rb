# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Govbr
    module DisplayMedias
      extend ActiveSupport::Concern
      include ParticipatorySpaceContext

      included do
        helper Decidim::Conferences::MediaAttachmentsHelper
        helper Decidim::SanitizeHelper

        participatory_space_layout only: :index

        helper_method :collection
      end

      def index
        raise ActionController::RoutingError, "No media_links for this participatory space #{current_participatory_space.class}" if media_links.empty? && current_participatory_space.attachments.empty?

        enforce_permission_to :list, :media_links
        redirect_to decidim_conferences.participatory_space_path(current_participatory_space) unless current_user_can_visit_space?
      end

      def collection
        media_links
      end

      def media_links
        @media_links ||= current_participatory_space.media_links
      end
    end
  end
end
