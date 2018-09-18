FROM microsoft/dotnet:2.1-sdk as build
WORKDIR /app

COPY source/netcore ./source/netcore
RUN dotnet restore source/netcore/fitSharp.sln

COPY source/fit ./source/netcore/fit
COPY source/fitSharp ./source/netcore/fitSharp
COPY source/fitTest ./source/netcore/fitTest
COPY source/fitSharpTest ./source/netcore/fitSharpTest
COPY source/Samples ./source/netcore/Samples
COPY source/Runner ./source/netcore/Runner
COPY source/TestTarget ./source/netcore/TestTarget
COPY source/netcore ./source/netcore
RUN dotnet publish source/netcore/fitSharp.sln -c Debug -o out --no-restore

FROM microsoft/dotnet:2.1-runtime
WORKDIR /
COPY document/fitSharp ./document/fitSharp
COPY storytest.config.xml ./
COPY --from=build \
   /app/source/netcore/fit/out \
   /app/source/netcore/fitSharp/out \
   /app/source/netcore/fitTest/out \
   /app/source/netcore/fitSharpTest/out \
   /app/source/netcore/Samples/out \
   /app/source/netcore/TestTarget/out \
   /app/source/netcore/Runner/out \
   ./build/sandbox/
   
  
ENTRYPOINT ["dotnet", "/build/sandbox/Runner.dll", "-r", "fit.Runner.FolderRunner", "-c", "storytest.config.xml"]
