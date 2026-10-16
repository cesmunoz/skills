# Investigation

This is a guide. It is the order of work for a read-only question. Each step names the role that does it. The role files do not repeat this list. Models for spawned roles are in `~/.agents/tero-roles.md`.

The result is a cited explanation, or a recommendation. It is not a code change.

The lead splits the question and hands the result back. The lead does not read the code, judge the answer, or write it. Independent slices are read at the same time: one researcher per slice, spawned in the same turn. A slice is one subsystem, one claim, or one option, and it does not need another slice's result. The read step is done when every researcher has replied.

| Step | Role | What to do |
| --- | --- | --- |
| 1. Split | lead | Name the independent slices of the question. If there is only one, say so. |
| 2. Read | researcher, one per slice | Read the code. Cite what you found. Say which explanation survives, and the tradeoff if this slice is an option. Do not change the code. Do not pick across slices. |
| 3. Judge | tech-lead | Read those findings. Accept one, or say what is wrong and which researcher should redo it. Do not write a different answer. If the premise is wrong, say so. |
| 4. Reply | technical-writer | Write the accepted answer in short, plain sentences. Use only the findings and the judgment. Cite the code. If the question is a choice, put the tradeoffs in a table. |
| 5. Hand back | lead | Do not open a pull request. If this is the start of a code change, stop and hand it back. A reported defect continues in the bug-fix guide. |
