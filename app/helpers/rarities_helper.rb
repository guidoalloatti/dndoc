module RaritiesHelper
  def rarities_sort_link(column, title)
    col = column.to_s
    current = params[:sort] == col
    next_dir = if current && params[:dir] == "asc" then "desc"
               elsif current && params[:dir] == "desc" then nil
               else "asc" end

    icon = if current && params[:dir] == "asc" then "bi-sort-up"
           elsif current && params[:dir] == "desc" then "bi-sort-down"
           else "bi-arrow-down-up opacity-25" end

    new_params = request.params.except("controller", "action")
    new_params = next_dir ? new_params.merge("sort" => col, "dir" => next_dir) : new_params.except("sort", "dir")
    css = current ? "text-decoration-none text-primary fw-semibold" : "text-decoration-none text-muted"

    link_to new_params, class: css do
      "#{title} <i class=\"bi #{icon} small\"></i>".html_safe
    end
  end
end
