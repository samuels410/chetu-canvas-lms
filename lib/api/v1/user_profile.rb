# frozen_string_literal: true

#
# Copyright (C) 2012 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

# includes Enrollment json helpers
module Api::V1::UserProfile
  include Api::V1::User

  def user_profile_json(profile, current_user, session, includes = [], context = @context)
    includes ||= []

    user = profile.user

    json = user_json(user, current_user, session, 'avatar_url', context)
    # don't unintentionally include stuff added to user_json
    json.slice! :id, :name, :short_name, :sortable_name, :sis_user_id,
                :sis_login_id, :login_id, :avatar_url, :integration_id, :pronouns

    json[:title] = profile.title
    json[:bio] = profile.bio
    json[:phone] = profile.phone
    json[:member_type] = profile.member_type
    json[:geographic_location] = profile.geographic_location
    json[:speciality_focus] = profile.speciality_focus
    json[:major] = profile.major
    json[:race] = profile.race
    json[:ethnicity] = profile.ethnicity
    json[:sexual_orientation] = profile.sexual_orientation
    json[:first_generation] = profile.first_generation
    json[:second_generation] = profile.second_generation
    json[:gender] = profile.gender
    json[:disability_status] = profile.disability_status
    json[:income_status] = profile.income_status
    json[:immigration_status] = profile.immigration_status
    json[:areas_of_interest] = profile.areas_of_interest
    json[:important_to_me] = profile.important_to_me
    json[:about_me] = profile.about_me
    json[:professional_interests_experiences] = profile.professional_interests_experiences
    json[:professional_goal] = profile.professional_goal
    json[:permanent_address] = profile.permanent_address
    json[:strength_weakness] = profile.strength_weakness
    json[:affiliation] = profile.affiliation
    json[:field_of_specialization] = profile.field_of_specialization
    json[:background_info_on_the_mentor] = profile.background_info_on_the_mentor
    json[:project_for_mentees] = profile.project_for_mentees
    json[:primary_email] = user.email if user.grants_right?(current_user, :read_email_addresses)
    json[:login_id] ||= user.primary_pseudonym.try(:unique_id)
    json[:integration_id] ||= user.primary_pseudonym.try(:integration_id)
    zone = user.time_zone || @domain_root_account.try(:default_time_zone) || Time.zone
    json[:time_zone] = zone.tzinfo.name
    json[:locale] = user.locale
    json[:effective_locale] = I18n.locale if user == current_user

    if user == current_user
      json[:calendar] = {:ics => "#{feeds_calendar_url(user.feed_code)}.ics"}
      json[:lti_user_id] = user.lti_context_id if user.lti_context_id.present?
    end

    if includes.include? 'user_services'
      services = user == current_user ?
        user.user_services :
        user.user_services.visible

      services = services.select{|s| feature_and_service_enabled?(s.service)}
      json[:user_services] = services.map { |s| user_service_json(s, current_user, session) }
    end

    if includes.include? 'links'
      json[:links] = profile.links.map { |l| user_profile_link_json(l, current_user, session) }
    end

    if includes.include? 'uuid'
      past_uuid = UserPastLtiId.uuid_for_user_in_context(user, context)
      json[:past_uuid] = past_uuid unless past_uuid == user.uuid
      json[:uuid] = user.uuid
    end

    json
  end

  def user_service_json(user_service, current_user, session)
    api_json(user_service, current_user, session,
             :only => %w(service visible),
             :methods => %(service_user_link))
  end

  def user_profile_link_json(link, current_user, session)
    api_json(link, current_user, session, :only => %w(url title))
  end
end
