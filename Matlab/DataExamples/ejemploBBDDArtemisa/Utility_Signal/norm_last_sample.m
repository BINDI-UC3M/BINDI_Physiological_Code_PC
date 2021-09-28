function out_s = norm_last_sample(in_s)
% out_s=in_s;
[num_videos,num_voluntarias]=size(in_s);
for loop_voluntarias=1:num_voluntarias    
    for loop_video=2:num_videos
        out_s(loop_video,loop_voluntarias).da=(in_s(loop_video,loop_voluntarias).da-in_s(loop_video-1,loop_voluntarias).da(end))/in_s(loop_video-1,loop_voluntarias).da(end);
        out_s(loop_video,loop_voluntarias).a=(in_s(loop_video,loop_voluntarias).a-in_s(loop_video-1,loop_voluntarias).a(end))/in_s(loop_video-1,loop_voluntarias).a(end);
        out_s(loop_video,loop_voluntarias).na=(in_s(loop_video,loop_voluntarias).na-in_s(loop_video-1,loop_voluntarias).na(end))/in_s(loop_video-1,loop_voluntarias).na(end);
        out_s(loop_video,loop_voluntarias).hemolizado=in_s(loop_video,loop_voluntarias).hemolizado;
        
    end
end

end