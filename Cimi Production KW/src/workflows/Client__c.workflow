<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_3_Month_reminder_to_Clinician</fullName>
        <ccEmails>cdsadmin@nctsn.org</ccEmails>
        <description>Send 3-Month reminder to Clinician</description>
        <protected>false</protected>
        <recipients>
            <field>Clinician_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Client_Due_for_Followup_3_Months</template>
    </alerts>
    <alerts>
        <fullName>Send_6_Month_reminder_to_Clinician</fullName>
        <ccEmails>cdsadmin@nctsn.org</ccEmails>
        <description>Send 6-Month reminder to Clinician</description>
        <protected>false</protected>
        <recipients>
            <field>Clinician_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Client_Due_for_Followup_6_Months</template>
    </alerts>
    <alerts>
        <fullName>Send_Test_Email</fullName>
        <description>Send Test Email</description>
        <protected>false</protected>
        <recipients>
            <field>Clinician_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Client_Due_for_Followup_TEST</template>
    </alerts>
</Workflow>
