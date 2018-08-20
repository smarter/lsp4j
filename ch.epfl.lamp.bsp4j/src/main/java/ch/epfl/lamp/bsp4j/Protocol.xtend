/*******************************************************************************
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.epfl.lamp.bsp4j

import java.util.ArrayList
import java.util.LinkedHashMap
import java.util.List
import java.util.Map
import org.eclipse.lsp4j.generator.JsonRpcData
import org.eclipse.lsp4j.jsonrpc.messages.Either
import org.eclipse.lsp4j.jsonrpc.messages.Either3
import org.eclipse.lsp4j.jsonrpc.validation.NonNull
import com.google.common.annotations.Beta

@JsonRpcData
class BuildTarget {
  /** The target’s unique identifier */
  @NonNull
  BuildTargetIdentifier id

  /** A human readable name for this target.
    * May be presented in the user interface.
    * Should be unique if possible.
    * The id.uri is used if None. */
  String displayName

  /** The category of this build target. */
  @NonNull
  BuildTargetKind kind

  /** The set of languages that this target contains.
    * The ID string for each language is defined in the LSP. */
  @NonNull
  List<String> languageIds

  @NonNull
  List<BuildTargetIdentifier> dependencies

  /** The capabilities of this build target. */
  @NonNull
  BuildTargetCapabilities capabilities

  /** Language-specific metadata about this target.
    * See ScalaBuildTarget as an example. */
  Object data

  new() {
  }

  new(@NonNull BuildTargetIdentifier id, String displayName, @NonNull BuildTargetKind kind, @NonNull List<String> languageIds,
      @NonNull List<BuildTargetIdentifier> dependencies, @NonNull BuildTargetCapabilities capabilities) {
    this.id = id
    this.displayName = displayName
    this.kind = kind
    this.languageIds = languageIds
    this.dependencies = dependencies
    this.capabilities = capabilities
  }

  new(@NonNull BuildTargetIdentifier id, String displayName, @NonNull BuildTargetKind kind, @NonNull List<String> languageIds,
      @NonNull List<BuildTargetIdentifier> dependencies, @NonNull BuildTargetCapabilities capabilities, Object data) {
    this(id, displayName, kind, languageIds, dependencies, capabilities)
    this.data = data
  }
}

/**
 * A unique identifier for a target.
 */
@JsonRpcData
class BuildTargetIdentifier {
	/**
	 * The text target's uri.
	 */
	@NonNull
	String uri

  new() {
  }
    
  new(@NonNull String uri) {
    this.uri = uri
  }
}

@JsonRpcData
class BuildTargetCapabilities {
  /** This target can be compiled by the BSP server. */
  Boolean canCompile
  /** This target can be tested by the BSP server. */
  Boolean canTest
  /** This target can be run by the BSP server. */
  Boolean canRun
}

/**
 * The parameters of a Workspace Build Targets Request.
 */
@JsonRpcData
class WorkspaceBuildTargetsParams {
}

@JsonRpcData
class WorkspaceBuildTargetsResult {
  /** The build targets in this workspace that
    * contain sources with the given language ids. */
	@NonNull
	List<BuildTarget> targets

  new() {
  }
    
  new(@NonNull List<BuildTarget> targets) {
    this.targets = targets
  }
}

/**
 * The parameters of a Workspace Build Targets Request.
 */
@JsonRpcData
class DidChangeBuildTargetParams {
  @NonNull
  List<BuildTargetEvent> changes

  new() {
  }

  new(@NonNull List<BuildTargetEvent> changes) {
    this.changes = changes
  }
}

@JsonRpcData
class BuildTargetEvent {
  /** The identifier for the changed build target */
  @NonNull
  String uri
  /** The kind of change for this build target */
  BuildTargetEventKind kind

  /** Any additional metadata about what information changed. */
  Object data

  new() {
  }

  new(@NonNull String uri) {
    this.uri = uri
  }

  new(@NonNull String uri, BuildTargetEventKind kind) {
    this(uri)
    this.kind = kind
  }

  new(@NonNull String uri,  BuildTargetEventKind kind, Object data) {
    this(uri, kind)
    this.data = data
  }
}

@JsonRpcData
class BuildTargetTextDocumentsParams {
  @NonNull List<BuildTargetIdentifier> targets

  new() {
  }

  new(@NonNull List<BuildTargetIdentifier> targets) {
    this.targets = targets
  }
}

@JsonRpcData
class BuildTargetTextDocumentsResponseResult {
  /** The source files used by this target */
  List<TextDocumentIdentifier> textDocuments
}

@JsonRpcData
class TextDocumentBuildTargetsParams {
  @NonNull TextDocumentIdentifier textDocument

  new() {
  }

  new(@NonNull TextDocumentIdentifier textDocument) {
    this.textDocument = textDocument
  }
}

@JsonRpcData
class TextDocumentBuildTargetsResult {
  List<BuildTargetIdentifier> targets
}

@JsonRpcData
class DependencySourcesParams {
  List<BuildTargetIdentifier> targets
}

@JsonRpcData
class DependencySourcesResult {
  List<DependencySourcesItem> items
}

@JsonRpcData
class DependencySourcesItem {
  BuildTargetIdentifier target
  /** List of resources containing source files of the
    * target's dependencies.
    * Can be source files, jar files, zip files, or directories. */
  List<String> sources
}

@JsonRpcData
class ResourcesParams {
  List<BuildTargetIdentifier> targets
}

@JsonRpcData
class ResourcesResult {
  List<ResourcesItem> items
}

@JsonRpcData
class ResourcesItem {
  BuildTargetIdentifier target
  /** List of resource files. */
  List<String> resources
}

@JsonRpcData
class CompileParams {
  @NonNull
  List<BuildTargetIdentifier> targets


  /** A unique identifier generated by the client to identify this request.
    * The server may include this id in triggered notifications or responses. */
  String originId

  /** Optional arguments to the compilation process. */
  @NonNull
  List<Object> arguments

  new() {
  }

  new(@NonNull List<BuildTargetIdentifier> targets, String originId, @NonNull List<Object> arguments) {
    this.targets = targets
    this.originId = originId
    this.arguments = arguments
  }
}

@JsonRpcData
class CompileReport {
  /** The build target that was compiled. */
  @NonNull BuildTargetIdentifier target
  
  /** An optional request id to know the origin of this report. */
  String originId

  /** The total number of reported errors compiling this target. */
  @NonNull
  Integer errors

  /** The total number of reported warnings compiling the target. */
  @NonNull
  Integer warnings

  /** The total number of milliseconds it took to compile the target. */
  Integer time

  new() {
  }

  new(@NonNull BuildTargetIdentifier target, String originId,
      @NonNull Integer errors, @NonNull Integer warnings, Integer time) {
    this.target = target
    this.originId = originId
    this.errors = errors
    this.warnings = warnings
    this.time = time
  }
}

@JsonRpcData
class ScalaBuildTarget {
  /** The Scala organization that is used for a target. */
  @NonNull
  String scalaOrganization

  /** The scala version to compile this target */
  @NonNull
  String scalaVersion

  /** The binary version of scalaVersion.
    * For example, 2.12 if scalaVersion is 2.12.4. */
  @NonNull
  String scalaBinaryVersion

  /** The target platform for this target */
  @NonNull
  ScalaPlatformKind platform
  
  /** A sequence of Scala jars. */
  @NonNull
  List<String> scalaJars

  new() {
  }

  new(@NonNull String scalaOrganization, @NonNull String scalaVersion, @NonNull String scalaBinaryVersion,
      @NonNull ScalaPlatformKind platform, @NonNull List<String> scalaJars) {
    this.scalaOrganization = scalaOrganization
    this.scalaVersion = scalaVersion
    this.scalaBinaryVersion = scalaBinaryVersion
    this.platform = platform
    this.scalaJars = scalaJars
  }
}

@JsonRpcData
class ScalacOptionsParams {
  List<BuildTargetIdentifier> targets
}

@JsonRpcData
class ScalacOptionsResult {
  List<ScalacOptionsItem> items
}

@JsonRpcData
class ScalacOptionsItem {
  @NonNull
  BuildTargetIdentifier target

  /** Additional arguments to the compiler.
    * For example, -deprecation. */
  @NonNull
  List<String> options
  
  /** The dependency classpath for this target, must be
    * identical to what is passed as arguments to
    * the -classpath flag in the command line interface
    * of scalac. */
  @NonNull
  List<String> classpath
  
  /** The output directory for classfiles produced by this target */
  @NonNull
  String classDirectory

  new() {
  }

  new(@NonNull BuildTargetIdentifier target, @NonNull List<String> options,
      @NonNull List<String> classpath, @NonNull String classDirectory) {
    this.target = target
    this.options = options
    this.classpath = classpath
    this.classDirectory = classDirectory
  }
}

@JsonRpcData
class DynamicRegistrationCapabilities {
	/**
     * Supports dynamic registration.
     */
    Boolean dynamicRegistration
    
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	this.dynamicRegistration = dynamicRegistration
    }
}

@JsonRpcData
class WorkspaceEditCapabilities {
	/**
	 * The client supports versioned document changes in `WorkspaceEdit`s
	 */
	Boolean documentChanges
    
    new() {
    }
    
    new(Boolean documentChanges) {
    	this.documentChanges = documentChanges
    }
}

@JsonRpcData
class DidChangeConfigurationCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class DidChangeWatchedFilesCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class SymbolCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class ExecuteCommandCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

/**
 * Workspace specific client capabilities.
 */
@JsonRpcData
class WorkspaceClientCapabilities {
	/**
     * The client supports applying batch edits to the workspace by supporting 
     * the request 'workspace/applyEdit'.
     */
    Boolean applyEdit
    
    /**
     * Capabilities specific to `WorkspaceEdit`s
     */
    WorkspaceEditCapabilities workspaceEdit
    
    /**
     * Capabilities specific to the `workspace/didChangeConfiguration` notification.
     */
    DidChangeConfigurationCapabilities didChangeConfiguration
    
    /**
     * Capabilities specific to the `workspace/didChangeConfiguration` notification.
     */
    DidChangeWatchedFilesCapabilities didChangeWatchedFiles
    
    /**
     * Capabilities specific to the `workspace/symbol` request.
     */
    SymbolCapabilities symbol
    
    /**
     * Capabilities specific to the `workspace/executeCommand` request.
     */
    ExecuteCommandCapabilities executeCommand
    
    /**
     * Capabilities specific to the `workspace/didChangeWorkspaceFolders` notification.
     * 
     * This API is a <b>proposal</b> from LSP and may change.
     */
    @Beta Boolean workspaceFolders
}

@JsonRpcData
class SynchronizationCapabilities extends DynamicRegistrationCapabilities {
    /**
     * The client supports sending will save notifications.
     */
    Boolean willSave
    
    /**
     * The client supports sending a will save request and
     * waits for a response providing text edits which will
     * be applied to the document before it is saved.
     */
    Boolean willSaveWaitUntil
    
    /**
     * The client supports did save notifications.
     */
    Boolean didSave
    
    new() {
    }
    
    new(Boolean willSave, Boolean willSaveWaitUntil, Boolean didSave) {
    	this.willSave = willSave
    	this.willSaveWaitUntil = willSaveWaitUntil
    	this.didSave = didSave
    }
    
    new(Boolean willSave, Boolean willSaveWaitUntil, Boolean didSave, Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    	this.willSave = willSave
    	this.willSaveWaitUntil = willSaveWaitUntil
    	this.didSave = didSave
    }
}

@JsonRpcData
class CompletionItemCapabilities {
	/**
     * Client supports snippets as insert text.
     *
     * A snippet can define tab stops and placeholders with `$1`, `$2`
     * and `${3:foo}`. `$0` defines the final tab stop, it defaults to
     * the end of the snippet. Placeholders with equal identifiers are linked,
     * that is typing in one will update others too.
     */
    Boolean snippetSupport
    
    new() {
    }
    
    new(Boolean snippetSupport) {
    	this.snippetSupport = snippetSupport
    }
}

@JsonRpcData
class CompletionCapabilities extends DynamicRegistrationCapabilities {     
    /**
	 * The client supports the following `CompletionItem` specific
	 * capabilities.
	 */
	CompletionItemCapabilities completionItem
    
    new() {
    }
    
    new(CompletionItemCapabilities completionItem) {
    	this.completionItem = completionItem
    }
    
    new(CompletionItemCapabilities completionItem, Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    	this.completionItem = completionItem
    }
}

@JsonRpcData
class HoverCapabilities extends DynamicRegistrationCapabilities {	
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class SignatureHelpCapabilities extends DynamicRegistrationCapabilities {	
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class ReferencesCapabilities extends DynamicRegistrationCapabilities {	
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class DocumentHighlightCapabilities extends DynamicRegistrationCapabilities {	
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class DocumentSymbolCapabilities extends DynamicRegistrationCapabilities {	
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class FormattingCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class RangeFormattingCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class OnTypeFormattingCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class DefinitionCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class CodeActionCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class CodeLensCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class DocumentLinkCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

@JsonRpcData
class RenameCapabilities extends DynamicRegistrationCapabilities {
    new() {
    }
    
    new(Boolean dynamicRegistration) {
    	super(dynamicRegistration)
    }
}

/**
 * Text document specific client capabilities.
 */
@JsonRpcData
class TextDocumentClientCapabilities {
	SynchronizationCapabilities synchronization
	
	/**
     * Capabilities specific to the `textDocument/completion`
     */
    CompletionCapabilities completion
    
    /**
     * Capabilities specific to the `textDocument/hover`
     */
    HoverCapabilities hover
    
    /**
     * Capabilities specific to the `textDocument/signatureHelp`
     */
    SignatureHelpCapabilities signatureHelp
    
    /**
     * Capabilities specific to the `textDocument/references`
     */
    ReferencesCapabilities references
    
    /**
     * Capabilities specific to the `textDocument/documentHighlight`
     */
    DocumentHighlightCapabilities documentHighlight
    
    /**
     * Capabilities specific to the `textDocument/documentSymbol`
     */
    DocumentSymbolCapabilities documentSymbol
    
    /**
     * Capabilities specific to the `textDocument/formatting`
     */
    FormattingCapabilities formatting
    
    /**
     * Capabilities specific to the `textDocument/rangeFormatting`
     */
    RangeFormattingCapabilities rangeFormatting
    
    /**
     * Capabilities specific to the `textDocument/onTypeFormatting`
     */
    OnTypeFormattingCapabilities onTypeFormatting
    
    /**
     * Capabilities specific to the `textDocument/definition`
     */
    DefinitionCapabilities definition
    
    /**
     * Capabilities specific to the `textDocument/codeAction`
     */
    CodeActionCapabilities codeAction
    
    /**
     * Capabilities specific to the `textDocument/codeLens`
     */
    CodeLensCapabilities codeLens
    
    /**
     * Capabilities specific to the `textDocument/documentLink`
     */
    DocumentLinkCapabilities documentLink
    
    /**
     * Capabilities specific to the `textDocument/rename`
     */
    RenameCapabilities rename
}

@JsonRpcData
class BuildClientCapabilities {
  /** The languages that this client supports.
    * The ID strings for each language is defined in the LSP.
    * The server must never respond with build targets for other
    * languages than those that appear in this list. */
  @NonNull
  List<String> languageIds
  
  /** The client can provide support for the file watching
    * notifications to the server. A language server can forward
    * these notifications from the editor. */
  @NonNull
  Boolean providesFileWatching
  
  new() {
  }
  
  new(@NonNull List<String> languageIds, @NonNull Boolean providesFileWatching) {
    this.languageIds = languageIds
    this.providesFileWatching = providesFileWatching
  }
}

/**
 * Contains additional diagnostic information about the context in which a code action is run.
 */
@JsonRpcData
class CodeActionContext {
	/**
	 * An array of diagnostics.
	 */
	@NonNull
	List<Diagnostic> diagnostics
    
    new() {
    	this(new ArrayList)
    }
    
    new(@NonNull List<Diagnostic> diagnostics) {
    	this.diagnostics = diagnostics
    }
}

/**
 * The code action request is sent from the client to the server to compute commands for a given text document and range.
 * The request is triggered when the user moves the cursor into an problem marker in the editor or presses the lightbulb
 * associated with a marker.
 */
@JsonRpcData
class CodeActionParams {
	/**
	 * The document in which the command was invoked.
	 */
	@NonNull
	TextDocumentIdentifier textDocument

	/**
	 * The range for which the command was invoked.
	 */
	@NonNull
	Range range

	/**
	 * Context carrying additional information.
	 */
	@NonNull
	CodeActionContext context
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument, @NonNull Range range, @NonNull CodeActionContext context) {
    	this.textDocument = textDocument
    	this.range = range
    	this.context = context
    }
}

/**
 * A code lens represents a command that should be shown along with source text, like the number of references,
 * a way to run tests, etc.
 * 
 * A code lens is <em>unresolved</em> when no command is associated to it. For performance reasons the creation of a
 * code lens and resolving should be done to two stages.
 */
@JsonRpcData
class CodeLens {
	/**
	 * The range in which this code lens is valid. Should only span a single line.
	 */
	@NonNull
	Range range

	/**
	 * The command this code lens represents.
	 */
	Command command

	/**
	 * An data entry field that is preserved on a code lens item between a code lens and a code lens resolve request.
	 */
	Object data
    
    new() {
    }
    
    new(@NonNull Range range) {
    	this.range = range
    }
    
    new(@NonNull Range range, Command command, Object data) {
    	this(range)
    	this.command = command
    	this.data = data
    }
}

/**
 * Code Lens options.
 */
@JsonRpcData
class CodeLensOptions {
	/**
	 * Code lens has a resolve provider as well.
	 */
	boolean resolveProvider
    
    new() {
    }
    
    new(boolean resolveProvider) {
    	this.resolveProvider = resolveProvider
    }
}

/**
 * The code lens request is sent from the client to the server to compute code lenses for a given text document.
 */
@JsonRpcData
class CodeLensParams {
	/**
	 * The document to request code lens for.
	 */
	@NonNull
	TextDocumentIdentifier textDocument
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument) {
    	this.textDocument = textDocument
    }
}

/**
 * Represents a reference to a command. Provides a title which will be used to represent a command in the UI and,
 * optionally, an array of arguments which will be passed to the command handler function when invoked.
 */
@JsonRpcData
class Command {
	/**
	 * Title of the command, like `save`.
	 */
	@NonNull
	String title

	/**
	 * The identifier of the actual command handler.
	 */
	@NonNull
	String command

	/**
	 * Arguments that the command handler should be invoked with.
	 */
	List<Object> arguments
    
    new() {
    }
    
    new(@NonNull String title, @NonNull String command) {
    	this.title = title
    	this.command = command
    }
    
    new(@NonNull String title, @NonNull String command, List<Object> arguments) {
    	this(title, command)
    	this.arguments = arguments
    }
}

/**
 * The Completion request is sent from the client to the server to compute completion items at a given cursor position.
 * Completion items are presented in the IntelliSense user class. If computing complete completion items is expensive
 * servers can additional provide a handler for the resolve completion item request. This request is send when a
 * completion item is selected in the user class.
 */
@JsonRpcData
class CompletionItem {
	/**
	 * The label of this completion item. By default also the text that is inserted when selecting this completion.
	 */
	@NonNull
	String label

	/**
	 * The kind of this completion item. Based of the kind an icon is chosen by the editor.
	 */
	CompletionItemKind kind

	/**
	 * A human-readable string with additional information about this item, like type or symbol information.
	 */
	String detail

	/**
	 * A human-readable string that represents a doc-comment.
	 */
	String documentation

	/**
	 * A string that shoud be used when comparing this item with other items. When `falsy` the label is used.
	 */
	String sortText

	/**
	 * A string that should be used when filtering a set of completion items. When `falsy` the label is used.
	 */
	String filterText

	/**
	 * A string that should be inserted a document when selecting this completion. When `falsy` the label is used.
	 */
	String insertText
	
	/**
     * The format of the insert text. The format applies to both the `insertText` property
     * and the `newText` property of a provided `textEdit`.
     */
    InsertTextFormat insertTextFormat

    /**
     * An edit which is applied to a document when selecting this completion. When an edit is provided the value of
     * `insertText` is ignored.
     *
     * *Note:* The range of the edit must be a single line range and it must contain the position at which completion
     * has been requested.
     */
    TextEdit textEdit

	/**
	 * An optional array of additional text edits that are applied when
	 * selecting this completion. Edits must not overlap with the main edit
	 * nor with themselves.
	 */
	List<TextEdit> additionalTextEdits

	/**
	 * An optional command that is executed *after* inserting this completion. *Note* that
	 * additional modifications to the current document should be described with the
	 * additionalTextEdits-property.
	 */
	Command command

	/**
	 * An data entry field that is preserved on a completion item between a completion and a completion resolve request.
	 */
	Object data
	
	new() {
	}
	
	new(@NonNull String label) {
		this.label = label
	}
}

/**
 * Represents a collection of completion items to be presented in the editor.
 */
@JsonRpcData
class CompletionList {
	/**
	 * This list it not complete. Further typing should result in recomputing this list.
	 */
	boolean isIncomplete

	/**
	 * The completion items.
	 */
	@NonNull
	List<CompletionItem> items
    
    new() {
    	this(new ArrayList)
    }
    
    new(@NonNull List<CompletionItem> items) {
    	this.items = items
    }
    
    new(boolean isIncomplete, @NonNull List<CompletionItem> items) {
    	this(items)
    	this.isIncomplete = isIncomplete
    }
}

/**
 * Completion options.
 */
@JsonRpcData
class CompletionOptions {
	/**
	 * The server provides support to resolve additional information for a completion item.
	 */
	Boolean resolveProvider

	/**
	 * The characters that trigger completion automatically.
	 */
	List<String> triggerCharacters
    
    new() {
    }
    
    new(Boolean resolveProvider, List<String> triggerCharacters) {
    	this.resolveProvider = resolveProvider
    	this.triggerCharacters = triggerCharacters
    }
}

/**
 * Represents a diagnostic, such as a compiler error or warning. Diagnostic objects are only valid in the scope of a resource.
 */
@JsonRpcData
class Diagnostic {
	/**
	 * The range at which the message applies
	 */
	@NonNull
	Range range

	/**
	 * The diagnostic's severity. Can be omitted. If omitted it is up to the client to interpret diagnostics as error,
	 * warning, info or hint.
	 */
	DiagnosticSeverity severity

	/**
	 * The diagnostic's code. Can be omitted.
	 */
	String code

	/**
	 * A human-readable string describing the source of this diagnostic, e.g. 'typescript' or 'super lint'.
	 */
	String source

	/**
	 * The diagnostic's message.
	 */
	@NonNull
	String message
	
	new() {
	}
	
	new(@NonNull Range range, @NonNull String message) {
		this.range = range
		this.message = message
	}
	
	new(@NonNull Range range, @NonNull String message, DiagnosticSeverity severity, String source) {
		this(range, message)
		this.severity = severity
		this.source = source
	}
	
	new(@NonNull Range range, @NonNull String message, DiagnosticSeverity severity, String source, String code) {
		this(range, message, severity, source)
		this.code = code
	}
}

/**
 * A notification sent from the client to the server to signal the change of configuration settings.
 */
@JsonRpcData
class DidChangeConfigurationParams {
	@NonNull
	Object settings
    
    new() {
    }
    
    new(@NonNull Object settings) {
    	this.settings = settings
    }
}

/**
 * The document change notification is sent from the client to the server to signal changes to a text document.
 */
@JsonRpcData
class DidChangeTextDocumentParams {
	/**
	 * The document that did change. The version number points to the version after all provided content changes have
	 * been applied.
	 */
	@NonNull
	VersionedTextDocumentIdentifier textDocument

	/**
	 * Legacy property to support protocol version 1.0 requests.
	 */
	@Deprecated
	String uri

	/**
	 * The actual content changes.
	 */
	@NonNull
	List<TextDocumentContentChangeEvent> contentChanges = new ArrayList
    
    new() {
    }
    
    new(@NonNull VersionedTextDocumentIdentifier textDocument, @NonNull List<TextDocumentContentChangeEvent> contentChanges) {
    	this.textDocument = textDocument
    	this.contentChanges = contentChanges
    }
    
    @Deprecated
    new(@NonNull VersionedTextDocumentIdentifier textDocument, String uri, @NonNull List<TextDocumentContentChangeEvent> contentChanges) {
    	this(textDocument, contentChanges)
    	this.uri = uri
    }
}

/**
 * The watched files notification is sent from the client to the server when the client detects changes
 * to file watched by the language client.
 */
@JsonRpcData
class DidChangeWatchedFilesParams {
	/**
	 * The actual file events.
	 */
	@NonNull
	List<FileEvent> changes
    
    new() {
    	this(new ArrayList)
    }
    
    new(@NonNull List<FileEvent> changes) {
    	this.changes = changes
    }
}

/**
 * The document close notification is sent from the client to the server when the document got closed in the client.
 * The document's truth now exists where the document's uri points to (e.g. if the document's uri is a file uri the
 * truth now exists on disk).
 */
@JsonRpcData
class DidCloseTextDocumentParams {
	/**
	 * The document that was closed.
	 */
	@NonNull
	TextDocumentIdentifier textDocument
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument) {
    	this.textDocument = textDocument
    }
}

/**
 * The document open notification is sent from the client to the server to signal newly opened text documents.
 * The document's truth is now managed by the client and the server must not try to read the document's truth using
 * the document's uri.
 */
@JsonRpcData
class DidOpenTextDocumentParams {
	/**
	 * The document that was opened.
	 */
	@NonNull
	TextDocumentItem textDocument

	/**
	 * Legacy property to support protocol version 1.0 requests.
	 */
	@Deprecated
	String text
    
    new() {
    }
    
    new(@NonNull TextDocumentItem textDocument) {
    	this.textDocument = textDocument
    }
    
    @Deprecated
	new(@NonNull TextDocumentItem textDocument, String text) {
    	this(textDocument)
    	this.text = text
    }
}

/**
 * The document save notification is sent from the client to the server when the document for saved in the clinet.
 */
@JsonRpcData
class DidSaveTextDocumentParams {
	/**
	 * The document that was closed.
	 */
	@NonNull
	TextDocumentIdentifier textDocument
	
	/**
     * Optional the content when saved. Depends on the includeText value
     * when the save notification was requested.
     */
    String text
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument) {
    	this.textDocument = textDocument
    }
    
    new(@NonNull TextDocumentIdentifier textDocument, String text) {
    	this(textDocument)
    	this.text = text
    }
}


@JsonRpcData
class WillSaveTextDocumentParams {
	/**
	 * The document that will be saved.
	 */
	@NonNull
	TextDocumentIdentifier textDocument
	
	/**
	 * A reason why a text document is saved.
	 */
	@NonNull
	TextDocumentSaveReason reason
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument, @NonNull TextDocumentSaveReason reason) {
    	this.textDocument = textDocument
    	this.reason = reason
    }
}

/**
 * The document formatting request is sent from the server to the client to format a whole document.
 */
@JsonRpcData
class DocumentFormattingParams {
	/**
	 * The document to format.
	 */
	@NonNull
	TextDocumentIdentifier textDocument

	/**
	 * The format options
	 */
	@NonNull
	FormattingOptions options
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument, @NonNull FormattingOptions options) {
    	this.textDocument = textDocument
    	this.options = options
    }
}

/**
 * A document highlight is a range inside a text document which deserves special attention. Usually a document highlight
 * is visualized by changing the background color of its range.
 */
@JsonRpcData
class DocumentHighlight {
	/**
	 * The range this highlight applies to.
	 */
	@NonNull
	Range range

	/**
	 * The highlight kind, default is {@link DocumentHighlightKind#Text}.
	 */
	DocumentHighlightKind kind
    
    new() {
    }
    
    new(@NonNull Range range) {
    	this.range = range
    }
    
    new(@NonNull Range range, DocumentHighlightKind kind) {
    	this(range)
    	this.kind = kind
    }
}

/**
 * A document link is a range in a text document that links to an internal or external resource, like another
 * text document or a web site.
 */
@JsonRpcData
class DocumentLink {
    /**
     * The range this link applies to.
     */
    @NonNull
    Range range
    
    /**
     * The uri this link points to. If missing a resolve request is sent later.
     */
    String target
    
    new() {
    }
    
    new(@NonNull Range range) {
    	this.range = range
    }
    
    new(@NonNull Range range, String target) {
    	this(range)
    	this.target = target
    }
}

@JsonRpcData
class DocumentLinkParams {
    /**
     * The document to provide document links for.
     */
    TextDocumentIdentifier textDocument
    
    new() {
    }
    
    new(TextDocumentIdentifier textDocument) {
    	this.textDocument = textDocument
    }
}

/**
 * Document link options
 */
@JsonRpcData
class DocumentLinkOptions {
	/**
     * Document links have a resolve provider as well.
     */
    Boolean resolveProvider
    
    new() {
    }
    
    new(Boolean resolveProvider) {
    	this.resolveProvider = resolveProvider
    }
}

/**
 * Execute command options.
 */
@JsonRpcData
class ExecuteCommandOptions {
	/**
     * The commands to be executed on the server
     */
    @NonNull
    List<String> commands
    
    new() {
    	this(new ArrayList)
    }
    
    new(@NonNull List<String> commands) {
    	this.commands = commands
    }
}

/**
 * Save options.
 */
@JsonRpcData
class SaveOptions {
	/**
     * The client is supposed to include the content on save.
     */
    Boolean includeText
    
    new() {
    }
    
    new(Boolean includeText) {
    	this.includeText = includeText
    }
}

@JsonRpcData
class TextDocumentSyncOptions {
	/**
     * Open and close notifications are sent to the server.
     */
    Boolean openClose
    /**
     * Change notifications are sent to the server. See TextDocumentSyncKind.None, TextDocumentSyncKind.Full
     * and TextDocumentSyncKind.Incremental.
     */
    TextDocumentSyncKind change
    /**
     * Will save notifications are sent to the server.
     */
    Boolean willSave
    /**
     * Will save wait until requests are sent to the server.
     */
    Boolean willSaveWaitUntil
    /**
     * Save notifications are sent to the server.
     */
    SaveOptions save
}

/**
 * Format document on type options
 */
@JsonRpcData
class DocumentOnTypeFormattingOptions {
	/**
	 * A character on which formatting should be triggered, like `}`.
	 */
	@NonNull
	String firstTriggerCharacter

	/**
	 * More trigger characters.
	 */
	List<String> moreTriggerCharacter
    
    new() {
    }
    
    new(@NonNull String firstTriggerCharacter) {
    	this.firstTriggerCharacter = firstTriggerCharacter
    }
    
    new(@NonNull String firstTriggerCharacter, List<String> moreTriggerCharacter) {
    	this.firstTriggerCharacter = firstTriggerCharacter
    	this.moreTriggerCharacter = moreTriggerCharacter
    }
}

/**
 * The document on type formatting request is sent from the client to the server to format parts of the document during typing.
 */
@JsonRpcData
class DocumentOnTypeFormattingParams extends DocumentFormattingParams {
	/**
	 * The position at which this request was send.
	 */
	@NonNull
	Position position

	/**
	 * The character that has been typed.
	 */
	@NonNull
	String ch
    
    new() {
    }
    
    new(@NonNull Position position, @NonNull String ch) {
    	this.position = position
    	this.ch = ch
    }
}

/**
 * The document range formatting request is sent from the client to the server to format a given range in a document.
 */
@JsonRpcData
class DocumentRangeFormattingParams extends DocumentFormattingParams {
	/**
	 * The range to format
	 */
	@NonNull
	Range range
    
    new() {
    }
    
    new(@NonNull Range range) {
    	this.range = range
    }
}

/**
 * The document symbol request is sent from the client to the server to list all symbols found in a given text document.
 */
@JsonRpcData
class DocumentSymbolParams {
	/**
	 * The text document.
	 */
	@NonNull
	TextDocumentIdentifier textDocument
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument) {
    	this.textDocument = textDocument
    }
}

/**
 * An event describing a file change.
 */
@JsonRpcData
class FileEvent {
	/**
	 * The file's uri.
	 */
	@NonNull
	String uri

	/**
	 * The change type.
	 */
	@NonNull
	FileChangeType type
    
    new() {
    }
    
    new(@NonNull String uri, @NonNull FileChangeType type) {
    	this.uri = uri
    	this.type = type
    }
}

/**
 * Value-object describing what options formatting should use.
 */
class FormattingOptions extends LinkedHashMap<String, Either3<String, Number, Boolean>> {

	static val TAB_SIZE = 'tabSize'
	static val INSERT_SPACES = 'insertSpaces'

    new() {
    }
    
    new(int tabSize, boolean insertSpaces) {
    	this.tabSize = tabSize
    	this.insertSpaces = insertSpaces
    }
    
    /**
     * @deprecated See https://github.com/eclipse/lsp4j/issues/99
     */
    @Deprecated
    new(int tabSize, boolean insertSpaces, Map<String, String> properties) {
    	this(tabSize, insertSpaces)
    	setProperties(properties)
    }
    
    def String getString(String key) {
    	get(key)?.getFirst
    }
    
    def void putString(String key, String value) {
    	put(key, Either3.forFirst(value))
    }
    
    def Number getNumber(String key) {
    	get(key)?.getSecond
    }
    
    def void putNumber(String key, Number value) {
    	put(key, Either3.forSecond(value))
    }
    
    def Boolean getBoolean(String key) {
    	get(key)?.getThird
    }
    
    def void putBoolean(String key, Boolean value) {
    	put(key, Either3.forThird(value))
    }
    
	/**
	 * Size of a tab in spaces.
	 */
    def int getTabSize() {
    	val value = getNumber(TAB_SIZE)
    	if (value !== null)
    		return value.intValue
    	else
    		return 0
    }
    
    def void setTabSize(int tabSize) {
    	putNumber(TAB_SIZE, tabSize)
    }
    
 	/**
	 * Prefer spaces over tabs.
	 */
    def boolean isInsertSpaces() {
       	val value = getBoolean(INSERT_SPACES)
    	if (value !== null)
    		return value
    	else
    		return false
    }
    
    def void setInsertSpaces(boolean insertSpaces) {
    	putBoolean(INSERT_SPACES, insertSpaces)
    }
    
    /**
     * @deprecated See https://github.com/eclipse/lsp4j/issues/99
     */
    @Deprecated
    def Map<String, String> getProperties() {
    	val properties = newLinkedHashMap
    	for (entry : entrySet) {
    		val value = switch it: entry.value {
    			case isFirst: getFirst
    			case isSecond: getSecond
    			case isThird: getThird
    		}
    		if (value !== null)
    			properties.put(entry.key, value.toString)
    	}
    	return properties.unmodifiableView
    }
    
    /**
     * @deprecated See https://github.com/eclipse/lsp4j/issues/99
     */
    @Deprecated
    def void setProperties(Map<String, String> properties) {
    	for (entry : properties.entrySet) {
    		putString(entry.key, entry.value)
    	}
    }
    
}

/**
 * The result of a hover request.
 */
@JsonRpcData
class Hover {
	/**
	 * The hover's content as markdown
	 */
	@NonNull
	List<Either<String, MarkedString>> contents

	/**
	 * An optional range
	 */
	Range range
    
    new() {
    }
    
    new(@NonNull List<Either<String, MarkedString>> contents) {
    	this.contents = contents
    }
    
    new(@NonNull List<Either<String, MarkedString>> contents, Range range) {
    	this.contents = contents
    	this.range = range
    }
}

/**
 * MarkedString can be used to render human readable text. It is either a markdown string
 * or a code-block that provides a language and a code snippet. The language identifier
 * is sematically equal to the optional language identifier in fenced code blocks in GitHub
 * issues. See https://help.github.com/articles/creating-and-highlighting-code-blocks/#syntax-highlighting
 *
 * The pair of a language and a value is an equivalent to markdown:
 * ```${language}
 * ${value}
 * ```
 *
 * Note that markdown strings will be sanitized - that means html will be escaped.
 */
@JsonRpcData
class MarkedString {
	@NonNull
	String language
	
	@NonNull
	String value
    
    new() {
    }
    
    new(@NonNull String language, @NonNull String value) {
    	this.language = language
    	this.value = value
    }
}

@JsonRpcData
class InitializeError {
	/**
	 * Indicates whether the client executes the following retry logic:
	 * (1) show the message provided by the ResponseError to the user
	 * (2) user selects retry or cancel
	 * (3) if user selected retry the initialize method is sent again.
	 */
	boolean retry
    
    new() {
    }
    
    new(boolean retry) {
    	this.retry = retry
    }
}

/**
 * Known error codes for an `InitializeError`
 */
interface InitializeErrorCode {
	/**
     * If the protocol version provided by the client can't be handled by the server.
     * 
     * @deprecated This initialize error got replaced by client capabilities.
     * There is no version handshake in version 3.0x
     */
    @Deprecated
    val unknownProtocolVersion = 1
}

/**
 * The initialize request is sent as the first request from the client to the server.
 */
@JsonRpcData
class InitializeBuildParams {
	/** The rootUri of the workspace */
  @NonNull
	String rootUri

	/** The capabilities of the client */
  @NonNull
	BuildClientCapabilities capabilities
	
	/**
   * The initial trace setting. If omitted trace is disabled ('off').
   * 
   * Legal values: 'off' | 'messages' | 'verbose'
   */
  String trace

  new() {
  }
  
  new(@NonNull String rootUri, @NonNull BuildClientCapabilities capabilities) {
    this.rootUri = rootUri
    this.capabilities = capabilities
  }
  new(@NonNull String rootUri, @NonNull BuildClientCapabilities capabilities, String trace) {
    this(rootUri, capabilities)
    this.trace = trace
  }
}

@JsonRpcData
class InitializeBuildResult {
	/**
	 * The capabilities of the build server
	 */
	@NonNull
	BuildServerCapabilities capabilities
    
    new() {
    }
    
    new(@NonNull BuildServerCapabilities capabilities) {
    	this.capabilities = capabilities
    }
}

@JsonRpcData
class InitializedBuildParams {
	
}

/**
 * Represents a location inside a resource, such as a line inside a text file.
 */
@JsonRpcData
class Location {
	@NonNull
	String uri

	@NonNull
	Range range
    
    new() {
    }
    
    new(@NonNull String uri, @NonNull Range range) {
    	this.uri = uri
    	this.range = range
    }
}

/**
 * The show message request is sent from a server to a client to ask the client to display a particular message in the
 * user class. In addition to the show message notification the request allows to pass actions and to wait for an
 * answer from the client.
 */
@JsonRpcData
class MessageActionItem {
	/**
	 * A short title like 'Retry', 'Open Log' etc.
	 */
	@NonNull
	String title
    
    new() {
    }
    
    new(@NonNull String title) {
    	this.title = title
    }
}

/**
 * The show message notification is sent from a server to a client to ask the client to display a particular message
 * in the user class.
 * 
 * The log message notification is send from the server to the client to ask the client to log a particular message.
 */
@JsonRpcData
class MessageParams {
	/**
	 * The message type.
	 */
	@NonNull
	MessageType type

	/**
	 * The actual message.
	 */
	@NonNull
	String message
    
    new() {
    }
    
    new(@NonNull MessageType type, @NonNull String message) {
    	this.type = type
    	this.message = message
    }
}

/**
 * Represents a parameter of a callable-signature. A parameter can have a label and a doc-comment.
 */
@JsonRpcData
class ParameterInformation {
	/**
	 * The label of this signature. Will be shown in the UI.
	 */
	@NonNull
	String label

	/**
	 * The human-readable doc-comment of this signature. Will be shown in the UI but can be omitted.
	 */
	String documentation
    
    new() {
    }
    
    new(@NonNull String label) {
    	this.label = label
    }
    
    new(@NonNull String label, String documentation) {
    	this.label = label
    	this.documentation = documentation
    }
}

/**
 * Position in a text document expressed as zero-based line and character offset.
 */
@JsonRpcData
class Position {
	/**
	 * Line position in a document (zero-based).
	 */
	int line

	/**
	 * Character offset on a line in a document (zero-based).
	 */
	int character
    
    new() {
    }
    
    new(int line, int character) {
    	this.line = line
    	this.character = character
    }
}

/**
 * Diagnostics notification are sent from the server to the client to signal results of validation runs.
 */
@JsonRpcData
class PublishDiagnosticsParams {
	/**
	 * The URI for which diagnostic information is reported.
	 */
	@NonNull
	String uri

	/**
	 * An array of diagnostic information items.
	 */
	@NonNull
	List<Diagnostic> diagnostics
    
    new() {
    	this.diagnostics = new ArrayList
    }
    
    new(@NonNull String uri, @NonNull List<Diagnostic> diagnostics) {
    	this.uri = uri
    	this.diagnostics = diagnostics
    }
}

/**
 * A range in a text document expressed as (zero-based) start and end positions.
 */
@JsonRpcData
class Range {
	/**
	 * The range's start position
	 */
	@NonNull
	Position start

	/**
	 * The range's end position
	 */
	@NonNull
	Position end
    
    new() {
    }
    
    new(@NonNull Position start, @NonNull Position end) {
    	this.start = start
    	this.end = end
    }
}

/**
 * The references request is sent from the client to the server to resolve project-wide references for the symbol
 * denoted by the given text document position.
 */
@JsonRpcData
class ReferenceContext {
	/**
	 * Include the declaration of the current symbol.
	 */
	boolean includeDeclaration
    
    new() {
    }
    
    new(boolean includeDeclaration) {
    	this.includeDeclaration = includeDeclaration
    }
}

/**
 * The references request is sent from the client to the server to resolve project-wide references for the symbol
 * denoted by the given text document position.
 */
@JsonRpcData
class ReferenceParams extends TextDocumentPositionParams {
	@NonNull
	ReferenceContext context
    
    new() {
    }
    
    new(@NonNull ReferenceContext context) {
    	this.context = context
    }
}

/**
 * The rename request is sent from the client to the server to do a workspace wide rename of a symbol.
 */
@JsonRpcData
class RenameParams {
	/**
	 * The document in which to find the symbol.
	 */
	@NonNull
	TextDocumentIdentifier textDocument

	/**
	 * The position at which this request was send.
	 */
	@NonNull
	Position position

	/**
	 * The new name of the symbol. If the given name is not valid the request must return a
	 * ResponseError with an appropriate message set.
	 */
	@NonNull
	String newName
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument, @NonNull Position position, @NonNull String newName) {
    	this.textDocument = textDocument
    	this.position = position
    	this.newName = newName
    }
}

@JsonRpcData
class BuildServerCapabilities {
  /**  The languages the server supports compilation via method buildTarget/compile. */
  CompileProvider compileProvider
  /** The languages the server supports test execution via method buildTarget/test */
  TestProvider testProvider
  /** The languages the server supports run via method buildTarget/run */
  RunProvider runProvider
  /** The server can provide a list of targets that contain a
    * single text document via the method textDocument/buildTargets */
  Boolean providesTextDocumentBuildTargets
  /** The server provides sources for library dependencies
    * via method buildTarget/dependencySources */
  Boolean providesDependencySources
  /** The server provides all the resource dependencies
    * via method buildTarget/resources */
  Boolean providesResources
  /** The server sends notifications to the client on build
    * target change events via buildTarget/didChange */
  Boolean providesBuildTargetChanged
}

@JsonRpcData
class CompileProvider {
  List<String> languageIds
}

@JsonRpcData
class TestProvider {
  List<String> languageIds
}

@JsonRpcData
class RunProvider {
  List<String> languageIds
}

/**
 * Capabilities of the server regarding workspace.
 * 
 * This is an LSP <b>proposal</b>.
 */
@Beta
@JsonRpcData
class WorkspaceServerCapabilities {
	  /**
     * Capabilities specific to the `workspace/didChangeWorkspaceFolders` notification.
     * 
     * This is an LSP <b>proposal</b>.
     */
    @Beta WorkspaceFoldersOptions workspaceFolders
}

/**
 * The show message request is sent from a server to a client to ask the client to display a particular message in the
 * user class. In addition to the show message notification the request allows to pass actions and to wait for an
 * answer from the client.
 */
@JsonRpcData
class ShowMessageRequestParams extends MessageParams {
	/**
	 * The message action items to present.
	 */
	List<MessageActionItem> actions
    
    new() {
    }
    
    new(List<MessageActionItem> actions) {
    	this.actions = actions
    }
}

/**
 * Signature help represents the signature of something callable. There can be multiple signature but only one
 * active and only one active parameter.
 */
@JsonRpcData
class SignatureHelp {
	/**
	 * One or more signatures.
	 */
	@NonNull
	List<SignatureInformation> signatures

	/**
	 * The active signature. If omitted or the value lies outside the
	 * range of `signatures` the value defaults to zero or is ignored if
	 * `signatures.length === 0`. Whenever possible implementors should 
	 * make an active decision about the active signature and shouldn't 
	 * rely on a default value.
	 * In future version of the protocol this property might become
	 * mandantory to better express this.
	 */
	Integer activeSignature

	/**
	 * The active parameter of the active signature. If omitted or the value
	 * lies outside the range of `signatures[activeSignature].parameters` 
	 * defaults to 0 if the active signature has parameters. If 
	 * the active signature has no parameters it is ignored. 
	 * In future version of the protocol this property might become
	 * mandantory to better express the active parameter if the
	 * active signature does have any.
	 */
	Integer activeParameter
    
    new() {
    	this.signatures = new ArrayList
    }
    
    new(@NonNull List<SignatureInformation> signatures, Integer activeSignature, Integer activeParameter) {
    	this.signatures = signatures
    	this.activeSignature = activeSignature
    	this.activeParameter = activeParameter
    }
}

/**
 * Signature help options.
 */
@JsonRpcData
class SignatureHelpOptions {
	/**
	 * The characters that trigger signature help automatically.
	 */
	List<String> triggerCharacters
    
    new() {
    }
    
    new(List<String> triggerCharacters) {
    	this.triggerCharacters = triggerCharacters
    }
}

/**
 * Represents the signature of something callable. A signature can have a label, like a function-name, a doc-comment, and
 * a set of parameters.
 */
@JsonRpcData
class SignatureInformation {
	/**
	 * The label of this signature. Will be shown in the UI.
	 */
	@NonNull
	String label

	/**
	 * The human-readable doc-comment of this signature. Will be shown in the UI but can be omitted.
	 */
	String documentation

	/**
	 * The parameters of this signature.
	 */
	List<ParameterInformation> parameters
    
    new() {
    }
    
    new(@NonNull String label) {
    	this.label = label
    }
    
    new(@NonNull String label, String documentation, List<ParameterInformation> parameters) {
    	this.label = label
    	this.documentation = documentation
    	this.parameters = parameters
    }
}

/**
 * Represents information about programming constructs like variables, classes, classs etc.
 */
@JsonRpcData
class SymbolInformation {
	/**
	 * The name of this symbol.
	 */
	@NonNull
	String name

	/**
	 * The kind of this symbol.
	 */
	@NonNull
	SymbolKind kind

	/**
	 * The location of this symbol.
	 */
	@NonNull
	Location location

	/**
	 * The name of the symbol containing this symbol.
	 */
	String containerName
	
    new() {
    }
    
    new(@NonNull String name, @NonNull SymbolKind kind, @NonNull Location location) {
    	this.name = name
    	this.kind = kind
    	this.location = location
    }
    
    new(@NonNull String name, @NonNull SymbolKind kind, @NonNull Location location, String containerName) {
    	this.name = name
    	this.kind = kind
    	this.location = location
    	this.containerName = containerName
    }
}

/**
 * An event describing a change to a text document. If range and rangeLength are omitted the new text is considered
 * to be the full content of the document.
 */
@JsonRpcData
class TextDocumentContentChangeEvent {
	/**
	 * The range of the document that changed.
	 */
	Range range

	/**
	 * The length of the range that got replaced.
	 */
	Integer rangeLength

	/**
	 * The new text of the range/document.
	 */
	@NonNull
	String text
    
    new() {
    }
    
    new(@NonNull String text) {
    	this.text = text
    }
    
    new(Range range, Integer rangeLength, @NonNull String text) {
    	this.range = range
    	this.rangeLength = rangeLength
    	this.text = text
    }
}

/**
 * Text documents are identified using an URI. On the protocol level URI's are passed as strings.
 */
@JsonRpcData
class TextDocumentIdentifier {
	/**
	 * The text document's uri.
	 */
	@NonNull
	String uri
    
    new() {
    }
    
    new(@NonNull String uri) {
    	this.uri = uri
    }
}

/**
 * An item to transfer a text document from the client to the server.
 */
@JsonRpcData
class TextDocumentItem {
	/**
	 * The text document's uri.
	 */
	@NonNull
	String uri

	/**
	 * The text document's language identifier
	 */
	@NonNull
	String languageId

	/**
	 * The version number of this document (it will strictly increase after each change, including undo/redo).
	 */
	int version

	/**
	 * The content of the opened  text document.
	 */
	@NonNull
	String text
    
    new() {
    }
    
    new(@NonNull String uri, @NonNull String languageId, int version, @NonNull String text) {
    	this.uri = uri
    	this.languageId = languageId
    	this.version = version
    	this.text = text
    }
}

/**
 * A parameter literal used in requests to pass a text document and a position inside that document.
 */
@JsonRpcData
class TextDocumentPositionParams {
	/**
	 * The text document.
	 */
	@NonNull
	TextDocumentIdentifier textDocument

	/**
	 * Legacy property to support protocol version 1.0 requests.
	 */
	@Deprecated
	String uri

	/**
	 * The position inside the text document.
	 */
	@NonNull
	Position position
    
    new() {
    }
    
    new(@NonNull TextDocumentIdentifier textDocument, @NonNull Position position) {
    	this.textDocument = textDocument
    	this.position = position
    }
    
    @Deprecated
	new(@NonNull TextDocumentIdentifier textDocument, String uri, @NonNull Position position) {
    	this.textDocument = textDocument
    	this.uri = uri
    	this.position = position
    }
}

/**
 * A textual edit applicable to a text document.
 */
@JsonRpcData
class TextEdit {
	/**
	 * The range of the text document to be manipulated. To insert text into a document create a range where start === end.
	 */
	@NonNull
	Range range

	/**
	 * The string to be inserted. For delete operations use an empty string.
	 */
	@NonNull
	String newText
    
    new() {
    }
    
    new(@NonNull Range range, @NonNull String newText) {
    	this.range = range
    	this.newText = newText
    }
}

/**
 * An identifier to denote a specific version of a text document.
 */
@JsonRpcData
class VersionedTextDocumentIdentifier extends TextDocumentIdentifier {
	/**
	 * The version number of this document.
	 */
	int version
    
    new() {
    }
    
    new(int version) {
    	this.version = version
    }
}

/**
 * Describes textual changes on a single text document.
 * The text document is referred to as a `VersionedTextDocumentIdentifier`
 * to allow clients to check the text document version before an edit is applied.
 */
@JsonRpcData
class TextDocumentEdit {
	/**
	 * The text document to change.
	 */
	@NonNull
	VersionedTextDocumentIdentifier textDocument
	
	/**
	 * The edits to be applied
	 */
	@NonNull
	List<TextEdit> edits
    
    new() {
    }
    
    new(@NonNull VersionedTextDocumentIdentifier textDocument, @NonNull List<TextEdit> edits) {
    	this.textDocument = textDocument
    	this.edits = edits
    }
}

/**
 * A workspace edit represents changes to many resources managed in the workspace. 
 * The edit should either provide `changes` or `documentChanges`.
 * If documentChanges are present they are preferred over `changes`
 * if the client can handle versioned document edits.
 */
@JsonRpcData
class WorkspaceEdit {
	/**
	 * Holds changes to existing resources.
	 */
	Map<String, List<TextEdit>> changes

	/**
	 * An array of `TextDocumentEdit`s to express changes to specific a specific
	 * version of a text document. Whether a client supports versioned document
	 * edits is expressed via `WorkspaceClientCapabilities.versionedWorkspaceEdit`.
	 */
	List<TextDocumentEdit> documentChanges
    
    new() {
    	this.changes = new LinkedHashMap
    }
    
    new(Map<String, List<TextEdit>> changes) {
    	this.changes = changes
    }
    
    new(List<TextDocumentEdit> documentChanges) {
    	this.documentChanges = documentChanges
    }
    
    /**
     * @deprecated According to the protocol documentation, it doesn't make sense to send both
     * 		changes and documentChanges
     */
    @Deprecated
    new(Map<String, List<TextEdit>> changes, List<TextDocumentEdit> documentChanges) {
    	this.changes = changes
    	this.documentChanges = documentChanges
    }
}

/**
 * The parameters of a Workspace Symbol Request.
 */
@JsonRpcData
class WorkspaceSymbolParams {
	/**
	 * A non-empty query string
	 */
	@NonNull
	String query
    
    new() {
    }
    
    new(@NonNull String query) {
    	this.query = query
    }
}

/**
 * General parameters to register for a capability.
 */
@JsonRpcData
class Registration {
	/**
     * The id used to register the request. The id can be used to deregister
     * the request again.
     */
    @NonNull
	String id
	
	/**
     * The method / capability to register for.
     */
    @NonNull
	String method
	
	/**
     * Options necessary for the registration.
     */
    Object registerOptions
    
    new() {
    }
    
    new(@NonNull String id, @NonNull String method) {
    	this.id = id
    	this.method = method
    }
    
    new(@NonNull String id, @NonNull String method, Object registerOptions) {
    	this.id = id
    	this.method = method
    	this.registerOptions = registerOptions
    }
}

@JsonRpcData
class RegistrationParams {
	@NonNull
	List<Registration> registrations
    
    new() {
    	this(new ArrayList)
    }
    
    new(@NonNull List<Registration> registrations) {
    	this.registrations = registrations
    }
}

/**
 * A document filter denotes a document through properties like language, schema or pattern.
 */
@JsonRpcData
class DocumentFilter {
	/**
     * A language id, like `typescript`.
     */
    String language
	
	/**
     * A uri scheme, like `file` or `untitled`.
     */
    String schema
	
	/**
     * A glob pattern, like `*.{ts,js}`.
     */
    String pattern
    
    new() {
    }
    
    new(String language, String schema, String pattern) {
    	this.language = language
    	this.schema = schema
    	this.pattern = pattern
    }
}

/**
 * A document selector is the combination of one or many document filters.
 */
interface DocumentSelector extends List<DocumentFilter> {
}

/**
 * Since most of the registration options require to specify a document selector there is a base interface that can be used.
 */
@JsonRpcData
class TextDocumentRegistrationOptions {
	/**
     * A document selector to identify the scope of the registration. If set to null
     * the document selector provided on the client side will be used.
     */
    DocumentSelector documentSelector
    
    new() {
    }
    
    new(DocumentSelector documentSelector) {
    	this.documentSelector = documentSelector
    }
}

/**
 * General parameters to unregister a capability.
 */
@JsonRpcData
class Unregistration {
	/**
     * The id used to unregister the request or notification. Usually an id
     * provided during the register request.
     */
    @NonNull
	String id
	
	/**
     * The method / capability to unregister for.
     */
    @NonNull
	String method
    
    new() {
    }
    
    new(@NonNull String id, @NonNull String method) {
    	this.id = id
    	this.method = method
    }
}

@JsonRpcData
class UnregistrationParams {
	@NonNull
	List<Unregistration> unregisterations
    
    new() {
    	this(new ArrayList)
    }
    
    new(@NonNull List<Unregistration> unregisterations) {
    	this.unregisterations = unregisterations
    }
}

/**
 * Describe options to be used when registered for text document change events.
 */
@JsonRpcData
class TextDocumentChangeRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
     * How documents are synced to the server. See TextDocumentSyncKind.Full 
     * and TextDocumentSyncKind.Incremental.
     */
    @NonNull
	TextDocumentSyncKind syncKind
    
    new() {
    }
    
    new(@NonNull TextDocumentSyncKind syncKind) {
    	this.syncKind = syncKind
    }
}

@JsonRpcData
class TextDocumentSaveRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
	 * The client is supposed to include the content on save.
	 */
	Boolean includeText
    
    new() {
    }
    
    new(Boolean includeText) {
    	this.includeText = includeText
    }
}

@JsonRpcData
class CompletionRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
     * The characters that trigger completion automatically.
     */
    List<String> triggerCharacters

    /**
     * The server provides support to resolve additional information for a completion item.
     */
    Boolean resolveProvider
    
    new() {
    }
    
    new(List<String> triggerCharacters, Boolean resolveProvider) {
    	this.triggerCharacters = triggerCharacters
    	this.resolveProvider = resolveProvider
    }
}

@JsonRpcData
class SignatureHelpRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
     * The characters that trigger signature help automatically.
     */
    List<String> triggerCharacters
    
    new() {
    }
    
    new(List<String> triggerCharacters) {
    	this.triggerCharacters = triggerCharacters
    }
}

@JsonRpcData
class CodeLensRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
     * Code lens has a resolve provider as well.
     */
    Boolean resolveProvider
    
    new() {
    }
    
    new(Boolean resolveProvider) {
    	this.resolveProvider = resolveProvider
    }
}

@JsonRpcData
class DocumentLinkRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
     * Document links have a resolve provider as well.
     */
    Boolean resolveProvider
    
    new() {
    }
    
    new(Boolean resolveProvider) {
    	this.resolveProvider = resolveProvider
    }
}

@JsonRpcData
class DocumentOnTypeFormattingRegistrationOptions extends TextDocumentRegistrationOptions {
	/**
     * A character on which formatting should be triggered, like `}`.
     */
    String firstTriggerCharacter
	/**
     * More trigger characters.
     */
    List<String> moreTriggerCharacter
    
    new() {
    }
    
    new(String firstTriggerCharacter, List<String> moreTriggerCharacter) {
    	this.firstTriggerCharacter = firstTriggerCharacter
    	this.moreTriggerCharacter = moreTriggerCharacter
    }
}

@JsonRpcData
class ExecuteCommandParams {
	/**
     * The identifier of the actual command handler.
     */
    @NonNull
	String command
	
	/**
     * Arguments that the command should be invoked with.
     * The arguments are typically specified when a command is returned from the server to the client.
     * Example requests that return a command are textDocument/codeAction or textDocument/codeLens.
     */
    List<Object> arguments
    
    new() {
    }
    
    new(@NonNull String command, List<Object> arguments) {
    	this.command = command
    	this.arguments = arguments
    }
}

/**
 * Execute command registration options.
 */
@JsonRpcData
class ExecuteCommandRegistrationOptions {
	/**
     * The commands to be executed on the server
     */
    List<String> commands
    
    new() {
    }
    
    new(List<String> commands) {
    	this.commands = commands
    }
}

@JsonRpcData
class ApplyWorkspaceEditParams {
	/**
     * The edits to apply.
     */
    WorkspaceEdit edit
    
    new() {
    }
    
    new(WorkspaceEdit edit) {
    	this.edit = edit
    }
}

@JsonRpcData
class ApplyWorkspaceEditResponse {
	/**
     * Indicates whether the edit was applied or not.
     */
    Boolean applied
    
    new() {
    }
    
    new(Boolean applied) {
    	this.applied = applied
    }
}

@Beta
@JsonRpcData
class WorkspaceFoldersOptions {
	/**
	 * The server has support for workspace folders
	 */
	Boolean supported
	
	/**
	 * Whether the server wants to receive workspace folder
	 * change notifications.
	 *
	 * If a strings is provided the string is treated as a ID
	 * under which the notification is registed on the client
	 * side. The ID can be used to unregister for these events
	 * using the `client/unregisterCapability` request.
	 */
	Either<String, Boolean> changeNotifications;
}

@Beta
@JsonRpcData
class WorkspaceFolder {
	/**
	 * The associated URI for this workspace folder.
	 */
	@NonNull String uri

	/**
	 * The name of the workspace folder. Defaults to the uri's basename.
	 */
	String name
}

@Beta
@JsonRpcData
class WorkspaceFoldersChangeEvent {
	/**
	 * The array of added workspace folders
	 */
	@NonNull
	List<WorkspaceFolder> added = new ArrayList

	/**
	 * The array of the removed workspace folders
	 */
	@NonNull
	List<WorkspaceFolder> removed = new ArrayList
}

@Beta
@JsonRpcData
class DidChangeWorkspaceFoldersParams {
	/**
	 * The actual workspace folder change event.
	 */
	@NonNull
	WorkspaceFoldersChangeEvent event
}
