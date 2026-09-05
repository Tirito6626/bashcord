# declaring all data arrays

#declare -gA intents=(
#    [Guilds]=1
#    [GuildMembers]=2
#    [GuildModeration]=4
#    [GuildExpressions]=8
#    [GuildIntegrations]=16
#    [GuildWebhooks]=32
#    [GuildInvites]=64
#    [GuildVoiceStates]=128
#    [GuildPresences]=256
#    [GuildMessages]=512
#    [GuildMessageReactions]=1024
#    [DirectMessages]=2048
#    [DirectMessageReactions]=4096
#    [DirectMessageTyping]=16384
#    [MessageContent]=32768
#    [GuildScheduledEvents]=65536
#    [AutoModerationConfiguration]=1048576
#    [AutoModerationExecution]=2097152
#    [GuildMessagePolls]=16777216
#    [DirectMessagePolls]=33554432
#)

declare -A application_install_types=(
    [guild_install]=0
    [user_install]=1
)

declare -A channel_types=(
    [guild_text]=0
    [dm]=1
    [guild_voice]=2
    [group_dm]=3
    [guild_category]=4
    [guild_announcement]=5
    [announcement_thread]=10
    [public_thread]=11
    [private_thread]=12
    [guild_stage_voice]=13
    [guild_directory]=14
    [guild_forum]=15
    [guild_media]=16
)

declare -A interaction_types=(
	[pong]=1
	[channel_message]=4
	[deferred_channel_message]=5
	[deferred_update_message]=6
	[update_message]=7
	[application_command_autocomplete_result]=8
	[modal]=9
)

declare -A activity_types=(
    [playing]=0
    [streaming]=1
    [listening]=2
    [watching]=3
    [custom]=4
    [competing]=5
)

declare -A button_styles=(
    [primary]=1
    [secondary]=2
    [success]=3
    [danger]=4
    [link]=5
    [premium]=6
)

declare -A application_types=(
    [chat_input]=1
    [slash]=1
    [user]=2
    [message]=3
    [primary_entry_point]=4
)

declare -A application_option_types=(
    [sub_command]=1
    [sub_command_group]=2
    [string]=3
    [integer]=4
    [boolean]=5
    [user]=6
    [channel]=7
    [role]=8
    [mentionable]=9
    [number]=10
    [attachment]=11
)

declare -A select_menu_types=(
    [string]=3
    [user]=5
    [role]=6
    [mentionable]=7
    [channel]=8
)