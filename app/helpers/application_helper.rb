module ApplicationHelper
  def rating_options(selected=nil)
    options_for_select((1..5).map {|num| [pluralize(num,"star"), num.to_f]}, selected)
  end
end
