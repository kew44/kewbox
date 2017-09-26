<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Followup_Visit_Due_Soon</fullName>
        <ccEmails>cdsadmin@nctsn.org</ccEmails>
        <description>Followup Visit Due Soon</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Client_Due_for_Followup_Visit</template>
    </alerts>
    <rules>
        <fullName>Followup Visit Due</fullName>
        <active>true</active>
        <criteriaItems>
            <field>DS_Background_Family_Info_B__c.BDOV__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Followup_Visit_Due_Soon</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DS_Background_Family_Info_B__c.BDOV__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>CIMI_Client_Followup_Visit_Due</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>DS_Background_Family_Info_B__c.BDOV__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>CIMI Client Followup Visit Due</subject>
    </tasks>
</Workflow>
