module EffectsHelper
  def effects_sort_link(column, title)
    col = column.to_s
    current = params[:sort] == col
    next_dir = if current && params[:dir] == "asc"
                 "desc"
               elsif current && params[:dir] == "desc"
                 nil
               else
                 "asc"
               end

    icon = if current && params[:dir] == "asc"
             "bi-sort-up"
           elsif current && params[:dir] == "desc"
             "bi-sort-down"
           else
             "bi-arrow-down-up opacity-25"
           end

    new_params = request.params.except("controller", "action")
    if next_dir
      new_params = new_params.merge("sort" => col, "dir" => next_dir)
    else
      new_params = new_params.except("sort", "dir")
    end

    css = current ? "text-decoration-none text-primary fw-semibold" : "text-decoration-none text-muted"

    link_to new_params, class: css do
      "#{title} <i class=\"bi #{icon} small\"></i>".html_safe
    end
  end

  def power_level_badge_class(level)
    case level
    when 0..1 then "bg-secondary"
    when 2..3 then "bg-success"
    when 4..5 then "bg-info"
    when 6..7 then "bg-warning text-dark"
    else "bg-danger"
    end
  end
end
