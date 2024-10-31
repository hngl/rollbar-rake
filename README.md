# Rollbar scripts in Ruby

Scripts for editing Rollbar items in bulk

## Usage

### List tasks

```
rake -T
```

### Delete all occurrences of certain Rollbar items

```
ROLLBAR_TOKEN=<CLEANUP_TOKEN> rake rollbar:delete_items <user_id>
```
