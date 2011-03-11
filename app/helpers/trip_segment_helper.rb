module TripSegmentHelper

  def longest_segment_length
    seg = TripSegment.longest_segment
    return seg.distance_in_miles unless seg.nil?
    return "No segments exisit"
  end
end
