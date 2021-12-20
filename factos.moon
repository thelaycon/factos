tests = require("tests")

passed = 0
failed = 0
time = os.clock()

for index,tests_table in pairs tests
  for index,test in pairs tests_table
    result, msg = pcall test
    
    print "\n"
    if result == true
      passed += 1
      print tostring(index).." passed\n"
    else
      failed +=1
      print tostring(index).." failed"
      print msg.."\n"

print "=====================\n\n"
print "Results:\n"
print "Passed: #{passed} tests."
print "Failed: #{failed} tests.\n"
print "Time taken: #{ string.format("%.2f", os.clock() - time)} seconds.\n"

if failed == 0
  print "============== All tests passed successfully =============="
  