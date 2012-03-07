// Our items ordering plugin
;(function($) {
	
	var defaults = {};
	
	// Helper to find first object in ary that f evaluates to true
	function find_first(ary, f) {
		for(var i in ary) {
			if(f(ary[i]))
				return ary[i];
		}
		return null;
	}
	
	
	function RailsAdminOrderItems($elem, args) {
		this.options = typeof args === 'Object' ? $.merge({}, defaults, args) : defaults;
		this.index_offset = parseInt(args.start_index, 10);
		this.elem = $elem;
		this.model_name = args.model_name;
		this.init();
	};
	
	RailsAdminOrderItems.prototype = {
		init : function() {
			var self = this;
			
			this.list = this.elem.find('#bulk_form table tbody');
			this.list_rows = this.list.find('tr');
			
			this.list.sortable({
				update: function() {
					self.onOrderUpdated();
				}
			})
			.find('input.order_index_input')
				.bind('keypress', function(e) {
     			self.onOrderInputUpdated(e, this);
				});
				
			$('#order_items')
				.live('pjax:complete', function() {
					setTimeout(function() {
						self.init();	
					}, 1000);
				});
		},
		
		onOrderInputUpdated : function(e, el) {
			// If key is not enter
			if(e.which !== 13)
				return;
						
			e.preventDefault();
			
			if($.isNumeric(el.value)) {
				$.post(
					'', 
					{
						order_action: 'place_item',
						order_model_name: this.model_name,
						item_data: {
							id: $(el).closest('tr').data('item_id'),
							index: parseInt(el.value, 10) - 1
						}
					},
					function(resp) {
						//window.location = window.location.href;
					},
					'json'
				);
			} else {
				alert("Input value must be numeric !");
			}
			// 
			setTimeout(function() {
				window.location = window.location.href;	
			}, 500);
			
		},
		
		onOrderUpdated : function() {
			var self = this;
			var data = {
				order_action: 'order_page',
				order_model_name: this.model_name,
				order_indexes : $.map(this.list.find('tr'), function(el, index) {
					var $el = $(el),
							// Calculate new index of current object
							new_index = index + self.index_offset;
					// Set new index in the input box
					$el
						.find('input.order_index_input')
						.val(new_index + 1); // We show values starting by 1 to the user !
					// Return hash {index: x,id: y} hash
					return {
						index: new_index,
						id: $el.data('item_id')
					};
				})
			};
			
			// Server-side ordering is made in background, don't show anything back to the user
			$.post('',data);
			
		}
	};
	
	$.fn.railsAdminOrderItems = function(args) {
		new RailsAdminOrderItems(this, args);
	};
})(jQuery);

// Launch plugin
$(function() {
	var $list =  $('.rails_admin #order_items'),
			$infos = $('#data_informations');
	
	if($list.length > 0)
		$list
			.railsAdminOrderItems({
				model_name : $infos.data('model_name'),
				start_index : $infos.data('start_index')
			});
});
