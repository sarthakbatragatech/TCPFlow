function [] = partB_cwnd(filename)
    file = readtable(filename, 'Format', '%s%s%s%s%s%s%s%s%s%s%s%s');
    file_cell = table2cell(file);
    file_cell = file_cell(:, 1:7);
    row = 1;
    flow1_cwnd = [];
    flow2_cwnd = [];
    flow1_time_cwnd = [];
    flow2_time_cwnd = [];
    cwnd = 1;
    while row < height(file)
        if length(file_cell{row, 6}) == length('cwnd_')
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
    figure
    %plot(flow1_time_cwnd, flow1_cwnd, 'r--')
    figure
    scatter(flow2_time_cwnd, flow2_cwnd)
end