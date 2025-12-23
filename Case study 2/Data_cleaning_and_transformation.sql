-- In the database tables that Danny has provided as a part of his 2nd case study (Pizza Runner), there is a requirement to
-- clean the data and also perform some transformations before we run some queries to gain insights.

-- In this file, the data cleaning and transformation operations are being done.

-- In the customer_orders table, the exclusions and extras field had null values, so they were replaced with blank spaces in the table (Temp tables can also be used)
SET exclusions =  CASE WHEN
		exclusions is null or exclusions = 'null' THEN ''
        ELSE exclusions
       END,
  extras = CASE WHEN 
  		extras is null or extras = 'null' THEN ''
        ELSE extras 
       	END;
        

-- Cleaned the runner_orders table (Temp tables can also be used)        
UPDATE runner_orders
SET pickup_time = 
	CASE WHEN 
    		pickup_time LIKE 'null' THEN ''
       	 ELSE
         	pickup_time
         END,
    distance =
    CASE WHEN
    		distance LIKE 'null' THEN ''
         WHEN
         	distance LIKE '%km' THEN TRIM('km' From distance)
         ELSE
         	distance
         END,
    duration = 
    CASE WHEN 
    		duration LIKE 'null' THEN ''
         WHEN
         	duration LIKE '%minutes' THEN TRIM('minutes' from duration)
         WHEN
         	duration LIKE '%mins' THEN TRIM('mins' from duration)
         WHEN
         	duration LIKE '%minute' THEN TRIM('minute' from duration)
         ELSE
            duration
         END,
    cancellation = 
    CASE WHEN 
    		cancellation LIKE 'null' or cancellation is null THEN ''
         ELSE 
         	cancellation
         END;