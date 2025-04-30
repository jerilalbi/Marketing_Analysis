SELECT * FROM engagement_data;

-- Duplicate check 
WITH DUP_CHECK AS (
	SELECT *,
    ROW_NUMBER() OVER(PARTITION BY EngagementID, ContentID, ContentType,
    Likes, EngagementDate, CampaignID, ProductID, ViewsClicksCombined ORDER BY EngagementID) AS RowNo
    FROM engagement_data
)

SELECT * FROM DUP_CHECK WHERE RowNo > 1;

UPDATE engagement_data 
SET ContentType = LOWER(ContentType);

SELECT EngagementID, ContentID,
REPLACE(ContentType, "socialmedia","social media") as ContentType, Likes, EngagementDate, CampaignID, ProductID,
SUBSTRING_INDEX(ViewsClicksCombined,'-',1) AS Views,
SUBSTRING_INDEX(ViewsClicksCombined,'-',-1) AS Clicks
FROM engagement_data
WHERE ContentType <> "newsletter"
ORDER BY 1;