##Contents
- [General](#general)
  * [Strategy](#strategy)
  * [Format and Commenting](#format-and-commenting)
- [Form Elements](#form-elements)
  * [Apex Structure](#apex-structure)
  * [Typography](#typography)
  * [Error Alerts](#error-alerts)
  * [Bootstrap Classes](#bootstrap-classes)
- [Form Types](#form-types)
  * [Vertical vs. Horizontal](#vertical-vs-horizontal)
  * [Matrix Form](#matrix-form)
- [Form Questions](#form-questions)
  * [Numbering](#numbering)
  * [Text Entry](#text-entry)
  * [Dropdown](#dropdown)
  * [Radio Button](#radio-button)
  * [Checkbox](#checkbox)
  * [Javascript/ Conditional Fields](#javascript-conditional-fields)

##General 
####Strategy
For structure and styling we've identified two strategies or scopes: Global & Inline/ Per-Page.

#####GLOBAL
As much as possible, style and structure are controlled by overarching Stylesheets and Javascripts. This means there are no styles inline, `style="..."`and `<style>` minimal `<script>`, and there is a universal header for all the pages, there are not unique resources linked to each page. The workflow:
- For each release, there is a span of time to style only UNIQUE elements, normal elements follow the global rules.
- This is a task that can happen at the end of development before release to users.

#####INLINE/ PER-PAGE
Rather than worrying about "Global" resources, each element is styled in a variety of ways and is styled to look the same despite the fact that they do not actually have the same set of resources attached (Stylesheets and Javascripts). The workflow:
- Each release is styled as it's being developed, all elements are styled both UNIQUE and NORMAL.
- This is a long term task that happens before and after release (realistically) this is a product of varying structures across pages and physical style sheets interacting with different browsers and devices. It's like you're putting makeup on your application and depending on the light, you might need to adjust.

**This document gives recommendations for a GLOBAL strategy.**

##Format and Commenting
I'd set my tabs to 4 spaces and would recommend commenting to assist in navigating code and for explaining what the code is doing. In a form view I would comment:
- Additional resources Javascript or CSS Beginning/ End of a Form
- Each Form Question
- Form Actions

For example, below, I've marked out the questions within a form. It is easy to find the questions and you can see in question 2, the piece of code `<apex:actionSupport>` will conditionally render question 2a:

```apex
<!-- 1. Date of visit (datepicker) --> 
<apex:outputPanel>
	<label>Date of visit</label> 
	<apex:outputPanel>
		<apex:inputField value="{!obj.BDOV__c}" type="date"/> 
	</apex:outputPanel>
</apex:outputPanel>

<!-- 2. Visit for episode of care --> 
<apex:outputPanel>
	<label>Question Label</label> 
	<apex:outputPanel>
		<apex:selectList id="CUREPI__c" value="{!qtwo}" size="1"> 
			<apex:selectOptions value="{!Q2Items}"/>
			<!-- rerenders 2a if "No" is selected --> 
			<apex:actionSupport event="onchange"
								rerender="CUREPVS" />
		</apex:selectList>
	</apex:outputPanel> 
</apex:outputPanel>

<!-- 2a. # of previous episodes of care (conditional) --> 
<apex:outputPanel id="CUREPVS">
	<apex:outputPanel rendered="{!IF(qtwo == '0', true, false)}" la yout="block">
		<apex:outputPanel>
			<label>Question Label</label> 
			<apex:outputPanel>
				<apex:inputField id="CUREPVS__c" value="{!obj.CUREPVS__c}" />
			</apex:outputPanel> 
		</apex:outputPanel>
	</apex:outputPanel> 
</apex:outputPanel>
```

Below, I can also collapse the code, to make it easy for non-programmers to read and understand what is going on:

```apex
<!-- 1. Date of visit (datepicker) --> 
<apex:outputPanel>
</apex:outputPanel>

<!-- 2. Visit for episode of care --> 
<apex:outputPanel>
</apex:outputPanel>

<!-- 2a. # of previous episodes of care (conditional) --> 
<apex:outputPanel id="CUREPVS">
</apex:outputPanel>
```

In a controller or trigger, I would comment:
- GET, POST, and DELETE actions (or Force.com equivalent)
- Unique actions (specific to a certain controller/ trigger)
- Connection between controller/ trigger actions and specific Questions in the view (i.e. creating an Array)
- Error checks/ validation

Below is ASP.NET I've commented out the GETfunction, but have not commented line-by- line because this is a super common function in an ASP.NET MVC application.

```asp.net
//
// GET: /Option/Details/
public ViewResult Details(int id = 0, string sortOrder = "", int page = 1){
	ViewBag.Title = "Program Option Details";
	Option option = db.Options.Find(id);
	return View("Details", "~/Views/Shared/_FullPageLayout.cshtml",option); 
}
```

The following is unique to the particular controller where it was used so I commented line-by-line:

```asp.net
var log = new OptionLog(); //new log
log.OptionKey = option.OptionID; //assign option key = option id
log.Name = option.Name; //assign name
log.CreatedOn = log.ModifiedOn = DateTime.Now; //set time for log entry
db.OptionLogs.Add(log); //add log to database
```

##Form Elements
####Apex Structure
I'd recommend that everything within the form panel adhere to the same framework so on pages with forms, wrap the entire `<apex:form>` tag in a `<divclass="bootwrap">`. General structure elements for all forms include: `<apex:sectionHeader>`,
`<apex:pageBlock>`, `<apex:pageBlockButtons>`, `<apex:pageMessages>`, and `<apex:pageBlockSection>`. See example below:

```apex
<div class="bootwrap"> 
	<apex:form>
		<apex:sectionHeader title="Form Title"/>
		<apex:pageBlock>
			<apex:pageBlockButtons> 
				<apex:commandButton value="Save"/> 
				<apex:commandButton value="Cancel"/>
			</apex:pageBlockButtons>
			<apex:pageMessages />
			<apex:pageBlockSection title="Form Section Title">
				Form Contents
			</apex:pageBlockSection>
			<apex:pageBlockSection title="Form Section Title">
				Form Contents 
			</apex:pageBlockSection>
		</apex:pageBlock> 
	</apex:form>
</div>
```

I'd think about the structure of the content and mentally align it to Apex elements. For example:

|Apex Structure Element | CIMI Structure Element |
|:--------------------- | :--------------------- |
| `<apex:sectionHeader>` | Associate with the section of CIMI such as Baseline, Follow-up, or Trauma History |
| `<apex:pageBlock>` | Associate with the link name on the summary page, for example "Baseline Visit and Demographic Information" |
| `<apex:pageBlockSection>` | Associate with the actual form within the page, these are collapsible which help with navigating a page that has multiple forms, for example "Baseline Visit" within the "Baseline Visit and Demographic Information" |
| `<apex:pageBlockButtons>` | As a navigational element should always appear at both the top and bottom of all forms with the same "Save" or "Cancel" options. |
| `<apex:pageMessages>` | This one is a little more complicated and I'll cover in Error Alerts. |

####Typography
There will be overlap with the hierarchy for your typography and the Apex structure elements mentioned above. I would outline the types of text in CIMI forms such as:
- Page Title
- Form Title
- Form Section Title Description Text Form Label Text
- Input Text
- Alert/ Error Text Copyright/ Credit Text

Then align to your hierarchy:


| Level | Typography | Tag(s) |
|:----- | :--------- | :----- |
| Heading 1 | Page Title | `<apex:sectionHeader>`, h1 |
| Heading 2 | Form Title | `<apex:pageBlock>`, h2 |
| Heading 3 | Form Section Title | `<apex:pageBlockSection>`, h3 |
| Paragraph (Lead) | Description Text | `<pclass="lead">` |
| Paragraph (Body) | Form Label Text, Input Text | No Class, Normal Paragraph Text |
| Paragraph (Bold) | Alert/ Error Text | `class="text-warning"`, `class="text-danger"` |
| Paragraph (Muted) | Copyright/ Credit Text | `class="text-muted"` |

####Error Alerts
I would decide on a standard way to handle error alerts across all forms. Basically your decision is whether to display alerts inline (directly beneath the field) or summarized at the top (as a bulleted list). Your decision here will affect the base form template above. It looks like `<apex:pageMessages>`, `<apex:pageMessage>`, and `<apex:messages>` are all designed to display either a single or multiple messages for the whole form, then
`<apex:message>` is designed for the inline-style of error reporting. I honestly did not look into this as much, but have it noted here to think about how this is handled on each form. Examples can be found in this blog post.

####Bootstrap Classes
I would use the styleClassproperty of the apex tags to add Bootstrap styling and follow the classes for Bootstrap forms. The Bootstrap resource is a custom build compiled with LESS to only work within `<divclass="bootwrap">`, but all of the other standard classes work.
So, first wrap your form with:

```apex
<apex:form id="SampleFormID" styleClass="form-horizontal">
￼	Questions Here! 
</apex:form>
```

Next add styles to the page buttons:

```apex
<apex:pageBlockButtons>
	<apex:commandButton styleClass="btn btn-primary btn-sm"/>
	<apex:commandButton styleClass="btn btn-default btn-sm"/> 
</apex:pageBlockButtons>
```

For each question group you'll want to add the styles for the Bootstrap `<div>` to the `<apex:outputPanel>` element and set layout="block"to make sure Apex outputs HTML `<div>`:

```apex
<apex:outputPanel styleClass="form-group" layout="block"> 
	<label class="control-label">Label Text</label>
	<apex:outputPanel layout="block">
		<apex:inputField styleClass="form-control"></apex:inputField>
	</apex:outputPanel>
</apex:outputPanel>
```

##Form Types
####Vertical vs Horizontal Form
Choose one or the other. A majority of CIMI forms are either horizontal forms, meaning the input appears next to the question text, or vertical, the input appears under the question text. I'd reccomend horizontal for longer forms, but would right-align text. Ultimately, its not the prettiest most ideal for designers, but usabilility wise, it's very clear for users.

####Matrix Form
Come up with rules and evaluate each form with a matrix individually. Think about:
- Forms where ALL questions have the same set of options (ex. Not True, Sometimes True, Always True).
- Forms where GROUPS of questions have the same set of options, but throughout the form, there may be up to 10 different groups.
- Forms where ONE or TWO questions have sub-statements with a set of options. 

Now come up with your rules:

| Form | Rules |
|:---- | :---- |
| ALL questions have same set of options | Use a simple divlayout with 50% devoted to the question text and 50% devoted to available options (divided evenly). |
| GROUPS of questions have same set of options | Give each set of options it's own div, similiar to the above, devote 50% to the question and 50% divided evenly among the available options. |
| ONE or TWO questions have sub-statements with a set of options | Treat like horizontal form. Use a divwith columns for options, placed next to question for consistency with the rest of the form. |

##Form Questions
####Numbering
The `label` tag is the only HTML tag that I found hard to replace with Apex while maintaining the Bootstrp structure/ style and a clean numbering scheme. Below, I wrapped the number in a `span` to control the margin between the question text and the number.

```apex
<label class="..."><span class="nmbr">1.</span>Date of visit</label >

```

####Text Entry
Fairly straight forward. If `<apex:inputField>` is wrapped with the appropriate Boostrap classes and structure you'll get a Bootstrap style text input field.

```apex
<apex:outputPanel styleClass="form-group" layout="block"> 
	<label class="col-md-4 control-label">Label Text</label>
	<apex:outputPanel styleClass="col-md-4" layout="block"> 
		<apex:inputField styleClass="form-control input-sm" />
	</apex:outputPanel> 
</apex:outputPanel>
```

Consider:
- Plain Text Fields
- Text Entry with Lookup
- Text Entry with Date Selector 
- Conditional Text Entry (Show/ Hide) 
- Text Entry with Error

####Dropdown
Also fairly straight forward, `<apex:selectList>` just needs to be wrapped with the appropriate Bootstrap classes to display the correct Bootstrap styled dropdown.

```apex
<apex:outputPanel styleClass="form-group" layout="block"> 
	<label class="col-md-4 control-label"></label>
	<apex:outputPanel styleClass="col-md-4" layout="block"> 
		<apex:selectList id="..." styleClass="form-control input-sm" size="1">
			<apex:selectOptions value="..."/> </apex:selectOptions> 
		</apex:selectList>
	</apex:outputPanel> 
</apex:outputPanel>
```

Consider:
- Plain Dropdown
- Dropdown with Ajax Animation (Conditional Fields Show/ Hide) 
- Dropdown with Error

####Radio Button
This is an area where we will need to work with what Apex produces since the radio button lists are generated with `<apex:selectRadio>`. In this case, to keep with Apex, I would break from Bootstrap and come up with custom styles - which can be applied to ALL radio button lists.

Consider:
- Radio Button List
- Radio Button Matrix 
- Radio Button with Error

####Checkbox
Here is where my testing ended. What I noticed is that lists of Checkboxes were manually created in the view (Visualforce Page). I would suggest creating an array in the controller to house your options then looping over options in the view. I would also move the "Other" checkbox option to the end of the list (usually it appears second to last or near the end). Usability-wise, I don't think it is common practice to breakup a list of checkbox options with Ajax in the middle of the list. In other words, when you click "Other" there is an animation that moves the list down and inserts a fill-in field, the common pattern for this is to have the "Other" checkbox at the end of the list so it does not disrupt the rest of the options.

Consider:
- Checkbox List
- Conditional Checkbox List (Show/ Hide)
- Checkbox with Ajax Animation (Conditional Fields Show/ Hide) 
- Checkbox with Error

####Javascript/ Conditional Fields
I'd use the Apex `<apex:actionSupport>` tag for Ajax "re-rendering" parts of the page. When I tested this in Salesforce their version of jQuery was old. I'd submit a help ticket to get this fixed and use the built-in Ajax and Javascript features. Below are examples of how to setup a trigger that releads a part of the page.

Triggers conditional event:

```apex
<apex:outputPanel>
	<label>Label Text</label> 
	<apex:outputPanel>
		<apex:selectList>
			<apex:selectOptions value="..."></apex:selectOptions>
			<apex:actionSupport event="onchange" 
								rerender="CUREPVS"></apex:actionSupport>
		</apex:selectList> 
	</apex:outputPanel>
</apex:outputPanel>
```

Section of form reloaded after event is triggered:

```apex
<apex:outputPanel id="CUREPVS">
	<apex:outputPanel rendered="{!IF(qtwo == '0', true, false)}">
		<apex:outputPanel> 
			<label>Label Text</label> 
			<apex:outputPanel>
				<apex:inputField></apex:inputField>
			</apex:outputPanel>
		</apex:outputPanel> 
	</apex:outputPanel>
</apex:outputPanel>
```
