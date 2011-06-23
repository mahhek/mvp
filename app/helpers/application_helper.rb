# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def year_select_for(model, field = :expDateYear)
    this_year = Time.now.year
    years = (this_year..( this_year + 10 )).map(&:to_s)
    select(model, field, years.map { |y| [y, y] },:selected => (value_for(model, field) || this_year.to_s), :html => {:class => "b-address-s"})
  end

  def month_select_for(model, field = :expDateMonth)
    months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    select(model, field, months.map { |m| [m, m] },:selected => (value_for(model, field) || months[Time.now.month - 1]), :html => {:class => "b-address-xs"})
  end

  def value_for(model, field)
    obj = instance_variable_get("@" + model.to_s)
    obj.respond_to?(field) ? obj.send(field) : nil
  end
end
