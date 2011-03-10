# t is the scope of the view / helpers.
# This will append it to a content_for section
# instead of directly in the page.
BHM::GoogleMaps.include_js_proc = proc do |t|
  t.content_for :extra_head, t.javascript_include_tag(t.google_maps_url(false), "gmap.js")
end

# BHM::GoogleMaps.address_to_lat_lng_proc
# BHM::GoogleMaps.address_to_lat_lng_proc.call("9229 Austin Ave, Morton Grove, Illinois 60053")