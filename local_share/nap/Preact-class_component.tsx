
interface MyClassProps
{
	class?: string
	id?: string
	style?: string
}
interface MyClassState {
	class?: string
}

// https://preactjs.com/guide/v10/components#class-components
class MyClass extends Component<MyClassProps, MyClassState>
{
	// Called on first load client & server side, before the client properly hydrates
	constructor(props: MyClassProps)
	{
		super(props)
		this.state = {
			class: props.class
		}
	}
	// Called client-side after the component hydrates, can cause obvious visual changes if this makes large changes to the render
	// componentDidMount(): void { }
	// For cleaning up intervals or external event listeners
	// componentWillUnmount(): void { }
	// Called after this.state changes
	// componentDidUpdate(previousProps: Readonly<MyClassProps>, previousState: Readonly<MyClassState>, snapshot: any): void { }
	render()
	{
		// TODO: Render something
		return <div class={this.state.class} id={this.props.id} style={this.props.style}>
			{/* TODO: */}
		</div>;
	}
}
