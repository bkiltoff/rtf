<cfquery name="branches" datasource="polaris" cachedwithin="#createTimespan(30,0,0,0)#">
	select O.abbreviation as branchAbbreviation
	from Organizations O with (nolock)
	order by abbreviation
</cfquery>

<cfset branch = #url.parameter# />

<cfquery name="rtfReport" datasource="polaris" maxrows="100" cachedwithin="#createTimespan(0,0,2,0)#">
<!--- this is a copy/paste of the sql query written by jon lellelid	--->
<!--- that fetches the rtf list for all branches						--->
select O.Abbreviation as Pickup, <!--- comment this line when updating for branches --->
         col.Name as CollectionName,
	     IsNull(hr.ItemBarcode, '') as ItemBarcode,
	     IsNull(ird.CallNumber, '') + IsNull(' ' + ird.VolumeNumber, '') AS 'CallNumber', 
	     ISNull(SHRST.BrowseAuthor, '') AS 'Author',
	     ISNull(sl.description, '') AS 'ShelfLocation',
	     IsNull(SHRST.BrowseTitle, '') + IsNull(' ' + COALESCE(i.Designation, hr.Designation, hr.VolumeNumber) + '', '') AS 'Title',
         IsNull(hr.Publisher, '') as Publisher,
	     br.PublicationYear  
from Polaris.SysHoldRequests hr with (nolock)  
INNER JOIN Polaris.BibliographicRecords br with (nolock) 
	on (hr.BibliographicRecordID = br.BibliographicRecordID)
INNER JOIN Organizations O with (nolock)
	on (hr.PickupBranchID = O.OrganizationID)
INNER JOIN Polaris.SysHoldRequestSearchTerms SHRST with (nolock) 
	on (hr.SysHoldRequestID = SHRST.SysHoldRequestID)  
LEFT JOIN Polaris.CircItemRecords cir with (nolock) 
	on (CASE WHEN hr.TrappingItemRecordID 	IS NOT NULL  
	THEN HR.TrappingItemRecordID 
	ELSE HR.ItemLevelHoldItemRecordID end = cir.ItemRecordID)   
LEFT JOIN Polaris.ItemRecordDetails ird with (nolock) 
	on (cir.ItemRecordID = ird.ItemRecordID)  
LEFT JOIN Polaris.Collections col with (nolock) 
	on (cir.AssignedCollectionID = col.CollectionID) 
LEFT JOIN Polaris.shelflocations sl with (nolock) 
	on (cir.shelflocationid = sl.shelflocationid) 
	and (cir.AssignedBranchID = sl.OrganizationID)  
LEFT JOIN Polaris.MfhdIssues i WITH (NOLOCK)  
	on  (hr.TrappingItemRecordID = i.ItemRecordID)   
WHERE hr.PickupBranchID 		in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27)  
<!---begin mucking about code here --->
	and O.Abbreviation like <cfqueryparam value="#branch#"  cfsqltype="cf_sql_varchar" />
<!---end mucking about code here --->
	and cir.ItemStatusID in (1)  <!---shelf --->
	and hr.SysHoldStatusID in (4)  <!---pending --->
	and hr.BorrowByMailRequest = 0 <!---Sno-Isle does not utilize Borrow by Mail --->
	and (sl.ShelfLocationID <> 12 <!---In Library Use Only --->
	   or sl.ShelfLocationID is Null)
ORDER BY O.Abbreviation, CollectionName asc, CallNumber asc
</cfquery>

<cfdump var="#branches#" />
<cfdump var="#rtfReport#" />