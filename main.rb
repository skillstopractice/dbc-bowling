require_relative "lib/frame"

frame1 = Frame.new(1)
frame1 << 10

frame2 = Frame.new(2)
frame1.next_frame = frame2

frame2 << 10

frame3 = Frame.new(3)
frame2.next_frame = frame3

frame3 << 10

p frame1.score

#first_frame << 5



#first_frame.next_frame.frame_number
