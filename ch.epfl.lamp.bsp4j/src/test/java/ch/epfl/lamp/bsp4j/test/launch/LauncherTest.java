/*******************************************************************************
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.epfl.lamp.bsp4j.test.launch;

import java.io.IOException;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.net.*;
import java.io.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;
import org.eclipse.lsp4j.CompletionList;
import org.eclipse.lsp4j.MessageParams;
import org.eclipse.lsp4j.MessageType;
import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.TextDocumentIdentifier;
import org.eclipse.lsp4j.TextDocumentPositionParams;
import org.eclipse.lsp4j.jsonrpc.*;
import org.eclipse.lsp4j.jsonrpc.messages.*;
import org.eclipse.lsp4j.jsonrpc.services.*;
import ch.epfl.lamp.bsp4j.*;
import ch.epfl.lamp.bsp4j.launch.*;
import ch.epfl.lamp.bsp4j.services.*;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.util.ToStringBuilder;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import static java.lang.System.out;
import static java.lang.System.err;

public class LauncherTest {

	private static final long TIMEOUT = 2000;

	@Test public void testInitialize() throws Exception {
    BuildServer server = clientLauncher.getRemoteProxy();

    List<String> list = new ArrayList<>();
    list.add("scala");

    BuildClientCapabilities cap = new BuildClientCapabilities(list, false);
    InitializeBuildParams params = new InitializeBuildParams("/home/smarter/opt/scala-seed-project", cap);
    InitializeBuildResult result = server.initialize(params).get();

    out.println("result: " + result);

    WorkspaceService workspace = server.getWorkspaceService();
    WorkspaceBuildTargetsParams bParams = new WorkspaceBuildTargetsParams();
    WorkspaceBuildTargetsResult bResult = workspace.buildTargets(bParams).get();

    out.println("bResult: " + bResult);

    BuildTargetService buildTarget = server.getBuildTargetService();
    CompileParams cParams = new CompileParams(bResult.getTargets().stream().map(t -> t.getId()).collect(Collectors.toList()), null, new ArrayList<>());
    CompileReport cReport = buildTarget.compile(cParams).get();

    out.println("cReport: " + cReport);
	}

	// @Test public void testRequest() throws Exception {

	// 	TextDocumentPositionParams p = new TextDocumentPositionParams();
	// 	p.setPosition(new Position(1,1));
	// 	p.setTextDocument(new TextDocumentIdentifier("test/foo.txt"));

	// 	CompletionList result = new CompletionList();
	// 	result.setIsIncomplete(true);
	// 	result.setItems(new ArrayList<>());

	// 	CompletionItem item = new CompletionItem();
	// 	item.setDetail("test");
	// 	item.setDocumentation("doc");
	// 	item.setFilterText("filter");
	// 	item.setInsertText("insert");
	// 	item.setKind(CompletionItemKind.Field);
	// 	result.getItems().add(item);

	// 	server.expectedRequests.put("textDocument/completion", new Pair<>(p, result));
	// 	CompletableFuture<Either<List<CompletionItem>, CompletionList>> future = clientLauncher.getRemoteProxy().getTextDocumentService().completion(p);
	// 	Assert.assertEquals(Either.forRight(result).toString(), future.get(TIMEOUT, TimeUnit.MILLISECONDS).toString());
	// 	client.joinOnEmpty();
	// }


	static class AssertingEndpoint implements Endpoint {

		public Map<String, Pair<Object, Object>> expectedRequests = new LinkedHashMap<>();

		@Override
		public CompletableFuture<?> request(String method, Object parameter) {
			Assert.assertTrue(expectedRequests.containsKey(method));
			Pair<Object, Object> result = expectedRequests.remove(method);
			Assert.assertEquals(result.getKey().toString(), parameter.toString());
			return CompletableFuture.completedFuture(result.getValue());
		}

		public Map<String, Object> expectedNotifications = new LinkedHashMap<>();

		@Override
		public void notify(String method, Object parameter) {
      out.println("Got notification method: " + method + " with parameter: " + parameter);
			// Assert.assertTrue(expectedNotifications.containsKey(method));
			// Object object = expectedNotifications.remove(method);
			// Assert.assertEquals(object.toString(), parameter.toString());
		}

		/**
		 * wait max 1 sec for all expectations to be removed
		 */
		public void joinOnEmpty() {
			long before = System.currentTimeMillis();
			do {
				if (expectedNotifications.isEmpty() && expectedNotifications.isEmpty()) {
					return;
				}
				try {
					Thread.sleep(100);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} while ( System.currentTimeMillis() < before + 1000);
			Assert.fail("expectations weren't empty "+toString());
		}

		@Override
		public String toString() {
			return new ToStringBuilder(this).addAllFields().toString();
		}

	}
	private AssertingEndpoint server;
	private Launcher<BuildClient> serverLauncher;
	private Future<?> serverListening;

	private AssertingEndpoint client;
	private Launcher<BuildServer> clientLauncher;
	private Future<?> clientListening;

	@Before public void setup() throws IOException {

    ServerSocket ss = new ServerSocket(4200);

    Socket clientSocket = ss.accept();  //new Socket("localhost", 4200);
		InputStream inClient = clientSocket.getInputStream();
		OutputStream outClient = clientSocket.getOutputStream();

		client = new AssertingEndpoint();
		clientLauncher = BSPLauncher.createClientLauncher(ServiceEndpoints.toServiceObject(client, BuildClient.class), inClient, outClient, false, new java.io.PrintWriter(System.err, true));
		clientListening = clientLauncher.startListening();
	}

	@After public void teardown() throws InterruptedException, ExecutionException {
		clientListening.cancel(true);
	}

}
