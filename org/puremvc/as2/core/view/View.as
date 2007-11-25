﻿/*
 PureMVC AS2 Port originally by Pedr Browne
 PureMVC - Copyright(c) 2006, 2007 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
import org.puremvc.as2.interfaces.*;
import org.puremvc.as2.patterns.observer.Observer;

class org.puremvc.as2.core.view.View implements IView
{

	public var name:String = "VIEW";

	/**
	 * A Singleton <code>IView</code> implementation.
	 * 
	 * <P>
	 * In PureMVC, the <code>View</code> class assumes these responsibilities:
	 * <UL>
	 * <LI>Maintain a cache of <code>IMediator</code> instances.</LI>
	 * <LI>Provide methods for registering, retrieving, and removing <code>IMediators</code>.</LI>
	 * <LI>Managing the observer lists for each <code>INotification</code> in the application.</LI>
	 * <LI>Providing a method for attaching <code>IObservers</code> to an <code>INotification</code>'s observer list.</LI>
	 * <LI>Providing a method for broadcasting an <code>INotification</code>.</LI>
	 * <LI>Notifying the <code>IObservers</code> of a given <code>INotification</code> when it broadcast.</LI>
	 * </UL>
	 * 
	 * @see org.puremvc.as2.patterns.mediator.Mediator Mediator
	 * @see org.puremvc.as2.patterns.observer.Observer Observer
	 * @see org.puremvc.as2.patterns.observer.Notification Notification
	 */
	
		/**
		 * Constructor. 
		 * 
		 * <P>
		 * This <code>IView</code> implementation is a Singleton, 
		 * so you should not call the constructor 
		 * directly, but instead call the static Singleton 
		 * Factory method <code>View.getInstance()</code>
		 * 
		 * @throws Error Error if Singleton instance has already been constructed
		 * 
		 */
		public function View( )
		{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			mediatorMap = new Array();
			observerMap = new Array();	
			initializeView();	
		}
		
		/**
		 * Initialize the Singleton View instance.
		 * 
		 * <P>
		 * Called automatically by the constructor, this
		 * is your opportunity to initialize the Singleton
		 * instance in your subclass without overriding the
		 * constructor.</P>
		 * 
		 * @return Void
		 */
		private function initializeView(  ) : Void 
		{
		}
	
		/**
		 * View Singleton Factory method.
		 * 
		 * @return the Singleton instance of <code>View</code>
		 */
		public static function getInstance() : IView 
		{
			if ( instance == null ) {
				instance = IView(new View( ));
			}
			return instance;
		}
				
		/**
		 * Register an <code>IObserver</code> to be notified
		 * of <code>INotifications</code> with a given name.
		 * 
		 * @param notificationName the name of the <code>INotifications</code> to notify this <code>IObserver</code> of
		 * @param observer the <code>IObserver</code> to register
		 */
		public function registerObserver ( notificationName:String, observer:IObserver ) : Void
		{
			if( observerMap[ notificationName ] != null ) {
				observerMap[ notificationName ].push( observer );
			} else {
				observerMap[ notificationName ] = [observer];
			}
		}
		
		/**
		 * Notify the <code>IObservers</code> for a particular <code>INotification</code>.
		 * 
		 * <P>
		 * All previously attached <code>IObservers</code> for this <code>INotification</code>'s
		 * list are notified and are passed a reference to the <code>INotification</code> in 
		 * the order in which they were registered.</P>
		 * 
		 * @param notification the <code>INotification</code> to notify <code>IObservers</code> of.
		 */
		public function notifyObservers( notification:INotification ) : Void
		{
			if( observerMap[ notification.getName() ] != null ) {
				var observers:Array = observerMap[ notification.getName()];
				for (var i:Number = 0; i < observers.length; i++) {
					var observer:IObserver = IObserver(observers[ i ]);
					observer.notifyObserver( notification );
				}
			}
		}
						
		/**
		 * Register an <code>IMediator</code> instance with the <code>View</code>.
		 * 
		 * <P>
		 * Registers the <code>IMediator</code> so that it can be retrieved by name,
		 * and further interrogates the <code>IMediator</code> for its 
		 * <code>INotification</code> interests.</P>
		 * <P>
		 * If the <code>IMediator</code> returns any <code>INotification</code> 
		 * names to be notified about, an <code>Observer</code> is created encapsulating 
		 * the <code>IMediator</code> instance's <code>handleNotification</code> method 
		 * and registering it as an <code>Observer</code> for all <code>INotifications</code> the 
		 * <code>IMediator</code> is interested in.</p>
		 * 
		 * @param mediatorName the name to associate with this <code>IMediator</code> instance
		 * @param mediator a reference to the <code>IMediator</code> instance
		 */
		public function registerMediator( mediator:IMediator ) : Void
		{
			// Register the Mediator for retrieval by name
			mediatorMap[ mediator.getMediatorName() ] = mediator;
			
			// Get Notification interests, if any.
			var interests:Array = mediator.listNotificationInterests();
			if ( interests.length == 0) return;
			
			// Create Observer
			var observer:Observer = new Observer( mediator.handleNotification, mediator );
			
			// Register Mediator as Observer for its list of Notification interests
			for ( var i:Number=0;  i<interests.length; i++ ) {
				registerObserver( interests[i],  observer );
			}			
		}

		/**
		 * Retrieve an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName the name of the <code>IMediator</code> instance to retrieve.
		 * @return the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
		 */
		public function retrieveMediator( mediatorName:String ) : IMediator
		{
			return mediatorMap[ mediatorName ];
		}

		/**
		 * Remove an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName name of the <code>IMediator</code> instance to be removed.
		 */
		public function removeMediator( mediatorName:String ) : Void
		{
			// Remove all Observers with a reference to this Mediator			
			// also, when an notification's observer list length falls to 
			// zero, remove it.
			for ( var notificationName:String in observerMap ) {
				var observers:Array = observerMap[ notificationName ];
				for ( var i:Number=0;  i< observers.length; i++ ) {
					if ( Observer(observers[i]).compareNotifyContext( retrieveMediator( mediatorName ) ) == true ) {
						observers.splice(i,1);
						if ( observers.length == 0 ) {
							delete observerMap[ notificationName ];								
							break;
						}
						
					}
				}
			}			
			// Remove the reference to the Mediator itself
			delete mediatorMap[ mediatorName ];
		}
						
		// Mapping of Mediator names to Mediator instances
		private var mediatorMap : Array;

		// Mapping of Notification names to Observer lists
		private var observerMap	: Array;
		
		// Singleton instance
		private static var instance	: IView;

		// Message Constants
		private var SINGLETON_MSG	: String = "View Singleton already constructed!";
	
}