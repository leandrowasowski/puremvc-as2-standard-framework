﻿/*
 PureMVC AS2 Port originally by Pedr Browne 
 PureMVC - Copyright(c) 2006, 2007 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
import org.puremvc.as2.interfaces.*;

interface org.puremvc.as2.interfaces.IFacade
{

	/**
	 * The interface definition for a PureMVC Facade.
	 *
	 * <P>
	 * The Facade Pattern suggests providing a single
	 * class to act as a central point of communication 
	 * for a subsystem. </P>
	 * 
	 * <P>
	 * In PureMVC, the Facade acts as an interface between
	 * the core MVC actors (Model, View, Controller) and
	 * the rest of your application.</P>
	 * 
	 * @see org.puremvc.as2.interfaces.IModel IModel
	 * @see org.puremvc.as2.interfaces.IView IView
	 * @see org.puremvc.as2.interfaces.IController IController
	 * @see org.puremvc.as2.interfaces.ICommand ICommand
	 * @see org.puremvc.as2.interfaces.INotification INotification
	 */
	
		/**
		 * Register an <code>IProxy</code> with the <code>Model</code> by name.
		 * 
		 * @param proxy the <code>IProxy</code> to be registered with the <code>Model</code>.
		 */
		function registerProxy( proxy:IProxy ) : Void;

		/**
		 * Retrieve a <code>IProxy</code> from the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the <code>IProxy</code> instance to be retrieved.
		 * @return the <code>IProxy</code> previously regisetered by <code>proxyName</code> with the <code>Model</code>.
		 */
		function retrieveProxy( proxyName:String ) : IProxy;
		
		/**
		 * Remove an <code>IProxy</code> instance from the <code>Model</code> by name.
		 *
		 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
		 */
		function removeProxy( proxyName:String ) : Void;
		
		/**
		 * Register an <code>ICommand</code> with the <code>Controller</code>.
		 * 
		 * @param noteName the name of the <code>INotification</code> to associate the <code>ICommand</code> with.
		 * @param commandClassRef a reference to the <code>Class</code> of the <code>ICommand</code>.
		 */
		function registerCommand( noteName : String, command : ICommand ) : Void
		
		/**
		 * Notify <code>Observer</code>s of an <code>INotification</code>.
		 * 
		 * @param note the <code>INotification</code> to have the <code>View</code> notify observers of.
		 */
		function notifyObservers( note:INotification ) : Void;
		
		/**
		 * Register an <code>IMediator</code> instance with the <code>View</code>.
		 * 
		 * @param mediator a reference to the <code>IMediator</code> instance
		 */
		function registerMediator( mediator:IMediator ) : Void;

		/**
		 * Retrieve an <code>IMediator</code> instance from the <code>View</code>.
		 * 
		 * @param mediatorName the name of the <code>IMediator</code> instance to retrievve
		 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
		 */
		function retrieveMediator( mediatorName:String ) : IMediator;

		/**
		 * Remove a <code>IMediator</code> instance from the <code>View</code>.
		 * 
		 * @param mediatorName name of the <code>IMediator</code> instance to be removed.
		 */
		function removeMediator( mediatorName:String ) : Void;

	
}