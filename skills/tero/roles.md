# Roles

This is the setup. It writes `models.md` in this folder. One line per role. Overwrite the whole file when it changes.

`inherit-parent` or `auto` means the role runs on the parent chat model.

The file it creates:

```
# budget: large (xhigh)
lead: inherit-parent
bug-fix: inherit-parent
```

| Role | What it does |
| --- | --- |
| lead | Plans, reviews, and verifies. Does not hand those off. |
| bug-fix | Implements the change with a specific scope. |
