# Rollbar scripts in Ruby

Scripts for editing Rollbar items in bulk

## Usage

### List tasks

```
rake -T
```

### Show Item Details
```bash
rake rollbar:show_item[project_item_id]
```
Shows detailed information about a Rollbar item using its project item ID (counter). This task will:
- Look up the item by its project item ID
- Display all available details about the item

### Delete Item
```bash
rake rollbar:delete_item[project_item_id]
```
Deletes a Rollbar item and all its occurrences using its project item ID (counter). This task will:
- Look up the item by its project item ID
- Delete all occurrences associated with the item
- Display the number of occurrences deleted


## Requirements
- Ruby (version specified in .ruby-version)
- Rollbar API access token (configured in environment)

