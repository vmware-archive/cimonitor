module CiMonitorHelper
  def build_count_text_for(project)
    return "" unless project.red?
    count = project.red_build_count
    "(#{count} #{count == 1 ? "build" : "builds"})"
  end

  def relative_status_messages_for(project)
    messages = []
    if project.online?
      messages << ['project_published_at', project.status.published_at.present? ? "Last built #{time_ago_in_words(project.status.published_at || DateTime.now)} ago" : "Last build date unknown"]
      if project.red?
        messages << ['project_red_since', project.red_since.present? ? "Red since #{time_ago_in_words(project.red_since)} ago #{build_count_text_for(project)}" : "Red for some time"]
      end
    else
      messages << ['project_invalid', "Could not retrieve status"]
    end
    messages
  end

  def static_status_messages_for(project)
    messages = []
    if project.online?
      messages << (project.status.published_at.present? ? "Last built #{project.status.published_at}": "Last build date unknown")
      if project.red?
        messages << (project.status.published_at.present? ? "Red since #{project.red_since} #{build_count_text_for(project)}" : "Red for some time")
      end
    else
      messages << "Could not retrieve status"
    end
    messages
  end

  def simple_time_for(event_time, apply_tense=false)
    if event_time.nil?
      return ''
    end
    total_seconds = (Time.now - event_time).round.to_i.abs
    days = total_seconds / 86400
    hours = (total_seconds / 3600) - (days * 24)
    minutes = (total_seconds / 60) - (hours * 60) - (days * 1440)
    seconds = total_seconds % 60

    simple_time = if days > 0
                    days.to_s+'d'
                  elsif hours > 0
                    hours.to_s+'h'
                  elsif minutes > 0
                    minutes.to_s+'m'
                  elsif seconds > 0
                    seconds.to_s+'s'
                  end
    if apply_tense
      simple_time + ((Time.now - event_time) > 0 ? " late" : " more")
    else
      simple_time
    end

    end
end
