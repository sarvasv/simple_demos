module ApplicationHelper
  #   * creates a link to the sortable column
  def sortable_column( column, display_text = nil)
    display_text ||= column.titleize # pcik given text, or titleize the name

    css = "current #{sort_direction}" if (column == sort_column)
    direction = (column == sort_column) && (sort_direction == "asc") ? "desc" : "asc"

    link_to( display_text, { :sort => column, :direction => direction}, {:class => css}) + 
    " #{ (direction == 'asc' ? ( column == sort_column ? 'v' : '') : '^')}"
  end
end
