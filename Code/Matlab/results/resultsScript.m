tests = {{'LW',1},{'Clifton',1},{'LW',2},{'Clifton',2},{'LW',3},{'Clifton',3}};
tests = {{'LW',3},{'Clifton',3}};


num_tests = length(tests);
conf_matrix = zeros(3,6);

for test_num = 1:num_tests
   test = tests{test_num}; 
   barrier = test{1}; total = test{2};
   computed = getResults(barrier,total);
   
   num_results = length(computed);
   for result_num = 1:num_results
        computed_num_vehicles = computed(result_num);
        conf_matrix(total,computed_num_vehicles + 1) = ...
            conf_matrix(total,computed_num_vehicles + 1) + 1
   end
    
end

conf_matrix