function [flow1_throughputs, flow2_throughputs,  time_axis] = partB(filename, finish_t)
    file = readtable(filename, 'Format', '%s%s%s%s%s%s%s%s%s%s%s%s');
    file_cell = table2cell(file);
    diff_sec = str2double(file_cell{1,2});
    start_time = str2double(file_cell{1,2});
    row = 2;
    flow1_segment_bytes = 0;
    flow2_segment_bytes = 0;
    time_axis = 0:100:100000;
    flow1_throughputs = [];
    flow2_throughputs = [];
    flow1_cwnd = [];
    flow2_cwnd = [];
    flow1_time_cwnd = [];
    flow2_time_cwnd = [];
    cwnd = 1;
    idx = 1;
    while str2double(file_cell{row,2}) <= finish_t
        while diff_sec < .1 && row < height(file)
            diff_sec = str2double(file_cell{row,2}) - start_time;
            if file_cell{row,5} == 'tcp'
                if file_cell{row, 8} == '0'
                    flow1_segment_bytes = flow1_segment_bytes + str2num(file_cell{row,6});
                else
                    flow2_segment_bytes = flow2_segment_bytes + str2num(file_cell{row,6});
                end
            elseif length(file_cell{row, 6}) == length('cwnd_')
                if file_cell{row, 6} == 'cwnd_'
                    if file_cell{row, 2} == '0'
                        flow1_cwnd(cwnd) = str2double(file_cell{row,7});
                        flow1_time_cwnd(cwnd) = str2double(file_cell{row,1});
                    end
                    if file_cell{row, 2} == '1'
                        flow2_cwnd(cwnd) = str2double(file_cell{row,7});
                        flow2_time_cwnd(cwnd) = str2double(file_cell{row,1});
                    end
                    cwnd = cwnd + 1;
                end
            end
            row = row + 1;
        end
        flow1_throughputs(idx) = flow1_segment_bytes/diff_sec;
        flow2_throughputs(idx) = flow2_segment_bytes/diff_sec;
        flow1_segment_bytes = 0;
        flow2_segment_bytes = 0;
        idx = idx + 1;
        start_time = str2double(file_cell{row,2});
        diff_sec = 0;
    end
    figure
    subplot(2,1,1)
    plot(1:length(flow1_throughputs), flow1_throughputs, 'r')
    xlabel('Time (seconds)')
    ylabel('Throughput (MB/s)')
    subplot(2,1,2)
    scatter(flow1_time_cwnd, flow1_cwnd)
    xlabel('Time (seconds)')
    ylabel('Congestion Window')
    figure
    subplot(2,1,1)
    plot(flow2_throughputs, 'r')
    xlabel('Time (seconds)')
    ylabel('Throughput (MB/s)')
    subplot(2,1,2)
    scatter(flow2_time_cwnd, flow2_cwnd)
    xlabel('Time (seconds)')
    ylabel('Congestion Window')
end