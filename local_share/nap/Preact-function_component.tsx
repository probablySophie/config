interface YourComponentProps 
{
	class?: string
	id?: string
	style?: string
}

function YourComponent(props: YourComponentProps)
{
	return <div class={props.class} id={props.id} style={props.style}>
		{/* TODO: */}
	</div>;
}
