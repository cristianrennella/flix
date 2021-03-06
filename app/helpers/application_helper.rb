module ApplicationHelper
	def my_form_for(record, options = {}, &proc)
		form_for(record, options.merge!({builder: MyFormBuilder}), &proc)
	end

	def options_for_video_reviews(selected=nil)
		options_for_select((1..5).to_a.map{ |rating| [pluralize(rating, "Star"), rating] }, selected)
	end
end