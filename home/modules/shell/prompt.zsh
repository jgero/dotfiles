parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_repo() {
	basename $(git rev-parse --show-toplevel)
}

git_info() {
	if git status &> /dev/null; then
		echo " ─ [  | $(parse_git_branch)@$(parse_git_repo) ]"
	fi
}

pending_tasks() {
	task status:pending count
}

pending_tasks_due_soon() {
	task due.before:1week status:pending count
}

task_info() {
	echo "[ ✓ | $(pending_tasks) | %F{red}$(pending_tasks_due_soon)%f ]"
}

NEWLINE=$'\n'

PROMPT='$NEWLINE┌─ $(task_info) ─ [ %T ] ─ [ ◌ | %1d ]$(git_info)$NEWLINE└─ > '
