function [flow1_tcp_count, flow1_throughput, flow2_tcp_count, flow2_throughput] = partA(filename)
    file = readtable(filename, 'Format', '%s%s%s%s%s%s%s%s%s%s%s%s');
    file_cell = table2cell(file);
    flow1_tcp_count = 0;
    flow1_segment_bytes = 0;
    flow2_tcp_count = 0;
    flow2_segment_bytes = 0;
    for row = 1:height(file)
        if file_cell{row,5} == 'tcp'
            if file_cell{row,1} ~= '-'
                if file_cell{row, 8} == '0'
                    flow1_segment_bytes = flow1_segment_bytes + str2num(file_cell{row,6});
                    if (file_cell{row, 4} == '5')
                        if (file_cell{row, 1} == 'r')
                            flow1_tcp_count = flow1_tcp_count + 1;
                        end
                    end
                else
                    flow2_segment_bytes = flow2_segment_bytes + str2num(file_cell{row,6});
                    if (file_cell{row, 4} == '6')
                        if (file_cell{row, 1} == 'r')
                            flow2_tcp_count = flow2_tcp_count + 1;
                        end
                    end
                end
            end
        end
    end
    time = str2double(file_cell{row,2});
    flow1_throughput = flow1_segment_bytes/time;
    flow2_throughput = flow2_segment_bytes/time;
end