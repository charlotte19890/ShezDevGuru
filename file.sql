ALTER   VIEW bpt.vw_com_demand AS
WITH 
total_rev AS (
    SELECT 
        'Total Revenue' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        1 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Revenue'
),
data_rev AS (
    SELECT 
        'Data Revenue' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        2 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Data revenue'
),
fwa_rev AS (
    SELECT 
        'FWA Revenue' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        4 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FWA revenue'
),
voice_rev AS (
    SELECT 
        'Voice Revenue' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        6 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Voice Revenue'
),
fintech_rev AS (
    SELECT 
        'Fintech Revenue' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        8 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Fintech revenue'
),
digital_rev AS (
    SELECT 
        'Digital Revenue' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        10 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Digital revenue'
),
total_opex AS (
    SELECT 
        'OPEX' AS group_list,
        previous_year,
        total_lc_prev AS previous_actual,
        current_year,
        total_lc_curr_f AS current_forecast,
        year1,
        total_lc_y1 AS year1_budget,
        year2,
        total_lc_y2 AS year2_budget,
        year3,
        total_lc_y3 AS year3_budget,
        business_unit_name,
        scenario,
        12 AS [order]
    FROM bpt.vw_opex_long_range_plan_latest
    WHERE group_list = 'Total OPEX'
),
total_capex AS (
    SELECT 
        'CAPEX' AS group_list,
        previous_year,
        total_lc_prev AS previous_actual,
        current_year,
        total_lc_curr_f AS current_forecast,
        year1,
        total_lc_y1 AS year1_budget,
        year2,
        total_lc_y2 AS year2_budget,
        year3,
        total_lc_y3 AS year3_budget,
        business_unit_name,
        scenario,
        16 AS [order]
    FROM bpt.vw_capex_long_range_plan_latest
    WHERE group_list = 'Total CAPEX'
),
ebitda AS (
    SELECT 
        group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        14 AS [order]
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'EBITDA'
),
subscribers AS (
    SELECT 
        group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Subscribers'
),
data_rev_per_sub AS (
    SELECT 
        'Data Revenue per Sub' AS group_list,
        data_rev.previous_year AS previous_year,
        data_rev.current_year AS current_year,
        ((TRY_CAST(data_rev.previous_actual AS DECIMAL(18,4)))/1000)*1000000 / NULLIF((TRY_CAST(subscribers.previous_actual AS DECIMAL(18,4)))/1000, 0) AS previous_actual,
        ((TRY_CAST(data_rev.current_forecast AS DECIMAL(18,4)))/1000)*1000000 / NULLIF(TRY_CAST(subscribers.current_forecast AS DECIMAL(18,4)), 0) AS current_forecast,
        data_rev.year1 AS year1,
        ((TRY_CAST(data_rev.year1_budget AS DECIMAL(18,4)))/1000)*1000000 / NULLIF(TRY_CAST(subscribers.year1_budget AS DECIMAL(18,4)), 0) AS year1_budget,
        data_rev.year2 AS year2,
        ((TRY_CAST(data_rev.year2_budget AS DECIMAL(18,4)))/1000)*1000000 / NULLIF(TRY_CAST(subscribers.year2_budget AS DECIMAL(18,4)), 0) AS year2_budget,
        data_rev.year3 AS year3,
        ((TRY_CAST(data_rev.year3_budget AS DECIMAL(18,4)))/1000)*1000000 / NULLIF(TRY_CAST(subscribers.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        data_rev.business_unit_name,
        data_rev.scenario,
        3 AS [order]
    FROM data_rev
    JOIN subscribers ON data_rev.business_unit_name = subscribers.business_unit_name 
                     AND data_rev.scenario = subscribers.scenario
),
fwa_rev_per_sub AS (
    SELECT 
        'FWA Revenue per Sub' AS group_list,
        fwa_rev.previous_year AS previous_year,
        fwa_rev.current_year AS current_year,
        TRY_CAST(fwa_rev.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.previous_actual AS DECIMAL(18,4)), 0) AS previous_actual,
        TRY_CAST(fwa_rev.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.current_forecast AS DECIMAL(18,4)), 0) AS current_forecast,
        fwa_rev.year1 AS year1,
        TRY_CAST(fwa_rev.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year1_budget AS DECIMAL(18,4)), 0) AS year1_budget,
        fwa_rev.year2 AS year2,
        TRY_CAST(fwa_rev.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year2_budget AS DECIMAL(18,4)), 0) AS year2_budget,
        fwa_rev.year3 AS year3,
        TRY_CAST(fwa_rev.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        fwa_rev.business_unit_name,
        fwa_rev.scenario,
        5 AS [order]
    FROM fwa_rev
    JOIN subscribers ON fwa_rev.business_unit_name = subscribers.business_unit_name 
                     AND fwa_rev.scenario = subscribers.scenario
),
voice_rev_per_sub AS (
    SELECT 
        'Voice Revenue per Sub' AS group_list,
        voice_rev.previous_year AS previous_year,
        voice_rev.current_year AS current_year,
        TRY_CAST(voice_rev.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.previous_actual AS DECIMAL(18,4)), 0) AS previous_actual,
        TRY_CAST(voice_rev.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.current_forecast AS DECIMAL(18,4)), 0) AS current_forecast,
        voice_rev.year1 AS year1,
        TRY_CAST(voice_rev.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year1_budget AS DECIMAL(18,4)), 0) AS year1_budget,
        voice_rev.year2 AS year2,
        TRY_CAST(voice_rev.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year2_budget AS DECIMAL(18,4)), 0) AS year2_budget,
        voice_rev.year3 AS year3,
        TRY_CAST(voice_rev.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        voice_rev.business_unit_name,
        voice_rev.scenario,
        7 AS [order]
    FROM voice_rev
    JOIN subscribers ON voice_rev.business_unit_name = subscribers.business_unit_name 
                     AND voice_rev.scenario = subscribers.scenario
),
fintech_rev_per_sub AS (
    SELECT 
        'Fintech Revenue per Sub' AS group_list,
        fintech_rev.previous_year AS previous_year,
        TRY_CAST(fintech_rev.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.previous_actual AS DECIMAL(18,4)), 0) AS previous_actual,
        fintech_rev.current_year AS current_year,
        TRY_CAST(fintech_rev.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.current_forecast AS DECIMAL(18,4)), 0) AS current_forecast,
        fintech_rev.year1  AS year1,
        TRY_CAST(fintech_rev.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year1_budget AS DECIMAL(18,4)), 0) AS year1_budget,
        fintech_rev.year2 AS year2,
        TRY_CAST(fintech_rev.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year2_budget AS DECIMAL(18,4)), 0) AS year2_budget,
        fintech_rev.year3 AS year3,
        TRY_CAST(fintech_rev.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        fintech_rev.business_unit_name,
        fintech_rev.scenario,
        9 AS [order]
        FROM fintech_rev
    JOIN subscribers ON fintech_rev.business_unit_name = subscribers.business_unit_name 
                     AND fintech_rev.scenario = subscribers.scenario
),
digital_rev_per_sub AS (
    SELECT 
        'Digital Revenue per Sub' AS group_list,
        digital_rev.previous_year AS previous_year,
        TRY_CAST(digital_rev.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.previous_actual AS DECIMAL(18,4)), 0) AS previous_actual,
        digital_rev.current_year AS current_year,
        TRY_CAST(digital_rev.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.current_forecast AS DECIMAL(18,4)), 0) AS current_forecast,
        digital_rev.year1 AS year1,
        TRY_CAST(digital_rev.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year1_budget AS DECIMAL(18,4)), 0) AS year1_budget,
        digital_rev.year2 AS year2,
        TRY_CAST(digital_rev.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year2_budget AS DECIMAL(18,4)), 0) AS year2_budget,
        digital_rev.year3 AS year3,
        TRY_CAST(digital_rev.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(subscribers.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        digital_rev.business_unit_name,
        digital_rev.scenario,
        11 AS [order]
    FROM digital_rev
    JOIN subscribers ON digital_rev.business_unit_name = subscribers.business_unit_name 
                     AND digital_rev.scenario = subscribers.scenario
),
opex_percentage_revenue AS (
    SELECT 
        'OPEX % Revenue' AS group_list,
        total_opex.previous_year AS previous_year,
        TRY_CAST(total_opex.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.previous_actual AS DECIMAL(18,4)), 0)  AS previous_actual,
        total_opex.current_year AS current_year,
        TRY_CAST(total_opex.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.current_forecast AS DECIMAL(18,4)), 0)  AS current_forecast,
        total_opex.year1 AS year1,
        TRY_CAST(total_opex.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year1_budget AS DECIMAL(18,4)), 0)  AS year1_budget,
        total_opex.year2 AS year2,
        TRY_CAST(total_opex.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year2_budget AS DECIMAL(18,4)), 0)  AS year2_budget,
        total_opex.year3 AS year3,
        TRY_CAST(total_opex.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        total_opex.business_unit_name,
        total_opex.scenario,
        13 AS [order]
    FROM total_opex
    JOIN total_rev ON total_opex.business_unit_name = total_rev.business_unit_name 
                  AND total_opex.scenario = total_rev.scenario
),
capex_percentage_revenue AS (
    SELECT 
        'CAPEX % Revenue' AS group_list,
        total_capex.previous_year  AS previous_year,
        TRY_CAST(total_capex.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.previous_actual AS DECIMAL(18,4)), 0)  AS previous_actual,
        total_capex.current_year AS current_year,
        TRY_CAST(total_capex.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.current_forecast AS DECIMAL(18,4)), 0)  AS current_forecast,
        total_capex.year1 AS year1,
        TRY_CAST(total_capex.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year1_budget AS DECIMAL(18,4)), 0)  AS year1_budget,
        total_capex.year2 AS year2,
        TRY_CAST(total_capex.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year2_budget AS DECIMAL(18,4)), 0)  AS year2_budget,
        total_capex.year3 AS year3,
        TRY_CAST(total_capex.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year3_budget AS DECIMAL(18,4)), 0)  AS year3_budget,
        total_capex.business_unit_name,
        total_capex.scenario,
        17 AS [order]
    FROM total_capex
    JOIN total_rev ON total_capex.business_unit_name = total_rev.business_unit_name 
                  AND total_capex.scenario = total_rev.scenario
),
ebitda_percentage_revenue AS (
    SELECT 
        'EBITDA % Revenue' AS group_list,
        ebitda.previous_year AS previous_year,
        TRY_CAST(ebitda.previous_actual AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.previous_actual AS DECIMAL(18,4)), 0)  AS previous_actual,
        ebitda.current_year  AS current_year,
        TRY_CAST(ebitda.current_forecast AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.current_forecast AS DECIMAL(18,4)), 0)  AS current_forecast,
        ebitda.year1  AS year1,
        TRY_CAST(ebitda.year1_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year1_budget AS DECIMAL(18,4)), 0) AS year1_budget,
        ebitda.year2  AS year2,
        TRY_CAST(ebitda.year2_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year2_budget AS DECIMAL(18,4)), 0) AS year2_budget,
        ebitda.year3  AS year3,
        TRY_CAST(ebitda.year3_budget AS DECIMAL(18,4)) / NULLIF(TRY_CAST(total_rev.year3_budget AS DECIMAL(18,4)), 0) AS year3_budget,
        ebitda.business_unit_name,
        ebitda.scenario,
        15 AS [order]
    FROM ebitda
    JOIN total_rev ON ebitda.business_unit_name = total_rev.business_unit_name 
                  AND ebitda.scenario = total_rev.scenario
),


-- non-financials

total_data_traffic AS (
    SELECT 
        'Data' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        18 AS [order],
        'Traffic' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'National - Total Data Volume [PB]'  AND business_unit_name = 'MTN Ghana'
),
--ERGB (Data rate)
total_data_rate AS (
    SELECT 
        'Data' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        19 AS [order],
        'Rate' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'ERGB (Data rate)'  
),
total_data_subscribers AS (
    SELECT 
        'Data' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        20 AS [order],
        'Subscribers' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Data subscribers'
),
total_voice_traffic AS (
    SELECT 
        'Voice' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        21 AS [order],
        'Traffic' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'National - Total Voice Traffic [Million Erl]'
),
total_voice_rate AS (
    SELECT 
        'Voice' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        22 AS [order],
        'Rate' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'ERM (Voice rate)'
),
total_voice_subscribers AS (
    SELECT 
        'Voice' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        23 AS [order],
        'Subscribers' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'Subscribers'
),

total_fwa_data_traffic AS (
    SELECT 
        'Fixed:FWA' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        24 AS [order],
        'Traffic' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FWA Total Data Traffic (%)'
),
total_fwa_data_rate AS (
    SELECT 
        'Fixed:FWA' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        25 AS [order],
        'Rate' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FWA ERGB Rate'
),
total_fwa_data_subscribers AS (
    SELECT 
        'Fixed:FWA' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        26 AS [order],
        'Subscribers' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FWA Subscribers'
),

total_fixed_ftth_data_traffic AS (
    SELECT 
        'Fixed:FTTH' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        27 AS [order],
        'Traffic' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FTTH Total Data Traffic'
),
total_fixed_ftth_data_rate AS (
    SELECT 
        'Fixed:FTTH' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        28 AS [order],
        'Rate' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FTTH ERGB Rate'
),

total_fixed_ftth_data_subscribers AS (
    SELECT 
        'Fixed:FTTH' AS group_list,
        previous_year,
        previous_actual,
        current_year,
        current_forecast,
        year1,
        year1_budget,
        year2,
        year2_budget,
        year3,
        year3_budget,
        business_unit_name,
        scenario,
        29 AS [order],
        'Subscribers' AS subsubkpi
    FROM bpt.vw_commercial_kpis
    WHERE group_list = 'FTTB Subscribers'
),
refresh_data AS (
    SELECT TOP 1 last_update_date 
    FROM bpt.vw_commercial_kpis 
    ORDER BY last_update_date DESC
)

SELECT combined_data.*,
    r.last_update_date
     FROM (
    SELECT *,'' AS  subsubkpi, 'Financials' AS kpi FROM total_rev
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM data_rev
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM data_rev_per_sub
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM fwa_rev
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM fwa_rev_per_sub
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM voice_rev
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM voice_rev_per_sub
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM fintech_rev
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM fintech_rev_per_sub
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM digital_rev
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM digital_rev_per_sub
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM total_opex 
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM opex_percentage_revenue
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM ebitda
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM ebitda_percentage_revenue
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM total_capex
    UNION ALL SELECT *,'' AS  subsubkpi,  'Financials' AS kpi FROM capex_percentage_revenue
    
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_data_traffic
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_data_rate
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_data_subscribers
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_voice_traffic
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_voice_rate
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_voice_subscribers
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_fwa_data_traffic
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_fwa_data_rate
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_fwa_data_subscribers
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_fixed_ftth_data_traffic
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_fixed_ftth_data_rate
    UNION ALL SELECT *, 'Non-Financials' AS kpi FROM total_fixed_ftth_data_subscribers
) AS combined_data 
CROSS JOIN refresh_data r;

