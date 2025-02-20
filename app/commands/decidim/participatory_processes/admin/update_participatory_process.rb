# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # A command with all the business logic when creating a new participatory
      # process in the system.
      class UpdateParticipatoryProcess < Decidim::Command
        include ::Decidim::AttachmentAttributesMethods

        # Public: Initializes the command.
        #
        # participatory_process - the ParticipatoryProcess to update
        # form - A form object with the params.
        def initialize(participatory_process, form)
          @participatory_process = participatory_process
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_participatory_process

          if @participatory_process.valid?
            broadcast(:ok, @participatory_process)
          else
            form.errors.add(:hero_image, @participatory_process.errors[:hero_image]) if @participatory_process.errors.include? :hero_image
            form.errors.add(:banner_image, @participatory_process.errors[:banner_image]) if @participatory_process.errors.include? :banner_image
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :participatory_process

        def update_participatory_process
          hide_custom_initial_page_component

          @participatory_process.assign_attributes(attributes)
          return unless @participatory_process.valid?

          @participatory_process.save!

          Decidim.traceability.perform_action!(:update, @participatory_process, form.current_user) do
            @participatory_process
          end
          link_related_processes
        end

        def attributes
          {
            title: form.title,
            subtitle: form.subtitle,
            weight: form.weight,
            slug: form.slug,
            hashtag: form.hashtag,
            promoted: form.promoted,
            description: form.description,
            short_description: form.short_description,
            scopes_enabled: form.scopes_enabled,
            scope: form.scope,
            scope_type_max_depth: form.scope_type_max_depth,
            private_space: form.private_space,
            developer_group: form.developer_group,
            local_area: form.local_area,
            area: form.area,
            target: form.target,
            participatory_scope: form.participatory_scope,
            participatory_structure: form.participatory_structure,
            meta_scope: form.meta_scope,
            start_date: form.start_date,
            end_date: form.end_date,
            participatory_process_group: form.participatory_process_group,
            participatory_process_type: form.participatory_process_type,
            show_metrics: form.show_metrics,
            show_statistics: form.show_statistics,
            announcement: form.announcement,
            initial_page_component_id: form.initial_page_component_id,
            initial_page_type: form.initial_page_type,
            group_chat_id: form.group_chat_id,
            publish_date: form.publish_date,
            should_have_user_full_profile: form.should_have_user_full_profile,
            show_mobilization: form.show_mobilization
          }.merge(
            attachment_attributes(:hero_image, :banner_image)
          )
        end

        def hide_custom_initial_page_component
          unless @participatory_process.initial_page_component_id.nil? || @participatory_process.initial_page_component_id.zero?
            previous_initial_page_component = Decidim::Component.find(@participatory_process.initial_page_component_id)
            previous_initial_page_component.update_column(:hide_in_menu, false)
          end

          return if form.initial_page_component_id.nil? || form.initial_page_component_id.zero?

          initial_page_component = Decidim::Component.find(form.initial_page_component_id)
          initial_page_component.update_column(:hide_in_menu, true)
        end

        def related_processes
          @related_processes ||= Decidim::ParticipatoryProcess.where(id: form.related_process_ids)
        end

        def link_related_processes
          @participatory_process.link_participatory_space_resources(related_processes, "related_processes")
        end
      end
    end
  end
end
